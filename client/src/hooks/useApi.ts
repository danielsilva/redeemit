import { useState, useEffect } from 'react'
import type { User, Reward, Redemption } from '../types'

const API_BASE_URL = window.redeemit?.API_BASE_URL || 'http://localhost:3000/api'

// Get current user ID from localStorage or default to 1
function getCurrentUserId(): number {
  const userId = localStorage.getItem('current_user_id')
  return userId ? parseInt(userId, 10) : 1
}

// Simple cache for demonstration
const cache = new Map<string, any>()

// Set of URLs that need to be refetched
const urlsToRefetch = new Set<string>()

// Subscribers for cache invalidation
const cacheSubscribers = new Set<() => void>()

// Hook to handle cache invalidation subscription
function useCacheInvalidationSubscription() {
  const [, forceUpdate] = useState({})
  
  useEffect(() => {
    const subscriber = () => forceUpdate({})
    cacheSubscribers.add(subscriber)
    return () => {
      cacheSubscribers.delete(subscriber)
    }
  }, [])
}

// Function to handle URL-specific cache invalidation
function handleCacheInvalidation(url: string) {
  if (urlsToRefetch.has(url) || urlsToRefetch.has('*')) {
    cache.delete(url)
    urlsToRefetch.delete(url)
    
    // If we cleared a specific URL and '*' was the only other entry, clear the set
    if (urlsToRefetch.size === 1 && urlsToRefetch.has('*')) {
      urlsToRefetch.clear()
    }
  }
}

// Function to get cached data or throw for Suspense
function getCachedData<T>(url: string): T | null {
  const cached = cache.get(url)
  
  if (cached) {
    if (cached.status === 'fulfilled') {
      return cached.data
    } else if (cached.status === 'rejected') {
      throw cached.error
    } else {
      // Still pending
      throw cached.promise
    }
  }
  
  // No cache entry exists
  return null
}

function fetchWithSuspense<T>(url: string): T {
  useCacheInvalidationSubscription()
  handleCacheInvalidation(url)
  
  const cachedResult = getCachedData<T>(url)
  if (cachedResult !== null) {
    return cachedResult
  }

  // Create promise for Suspense
  const promise = fetch(url)
    .then(response => response.json())
    .then(
      data => {
        cache.set(url, { status: 'fulfilled', data })
        return data
      },
      error => {
        cache.set(url, { status: 'rejected', error })
        throw error
      }
    )

  cache.set(url, { status: 'pending', promise })
  throw promise
}

export function useUser(): User {
  const userId = getCurrentUserId()
  return fetchWithSuspense<User>(`${API_BASE_URL}/users/${userId}/balance`)
}

export function useRewards(): Reward[] {
  return fetchWithSuspense<Reward[]>(`${API_BASE_URL}/rewards`)
}

export function useRedemptions(): Redemption[] {
  const userId = getCurrentUserId()
  return fetchWithSuspense<Redemption[]>(`${API_BASE_URL}/users/${userId}/redemptions`)
}

// Helper to clear cache (for after mutations)
export function invalidateCache(url?: string) {
  if (url) {
    cache.delete(url)
    urlsToRefetch.add(url)
  } else {
    cache.clear()
    urlsToRefetch.add('*') // Special marker for "refetch all"
  }
  
  // Notify all subscribers to trigger re-renders
  cacheSubscribers.forEach(subscriber => subscriber())
}

// Mutation for redeeming rewards
export async function redeemReward(rewardId: number): Promise<void> {
  const response = await fetch(`${API_BASE_URL}/redemptions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user_id: getCurrentUserId(),
      reward_id: rewardId
    })
  })
  
  if (!response.ok) {
    const error = await response.json()
    throw new Error(error.error || 'Failed to redeem reward')
  }
  
  // Clear specific cache entries for user points and rewards
  const userId = getCurrentUserId()
  invalidateCache(`${API_BASE_URL}/users/${userId}/balance`)
  invalidateCache(`${API_BASE_URL}/rewards`)
  invalidateCache(`${API_BASE_URL}/users/${userId}/redemptions`)
}

// Hook for redemption mutation
export function useRedeemReward() {
  return {
    redeemReward: async (rewardId: number) => {
      try {
        await redeemReward(rewardId)
        return { success: true, error: null }
      } catch (error) {
        return { 
          success: false, 
          error: error instanceof Error ? error.message : 'Failed to redeem reward' 
        }
      }
    }
  }
}