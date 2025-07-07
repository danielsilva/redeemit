import { useEffect, useState } from 'react'
import type { User, Reward, Redemption } from '../types'

const API_BASE_URL = 'http://localhost:3000/api'

// Simple cache for demonstration
const cache = new Map<string, any>()

function fetchWithSuspense<T>(url: string): T {
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
  return fetchWithSuspense<User>(`${API_BASE_URL}/users/1/balance`)
}

export function useRewards(): Reward[] {
  return fetchWithSuspense<Reward[]>(`${API_BASE_URL}/rewards`)
}

export function useRedemptions(): Redemption[] {
  return fetchWithSuspense<Redemption[]>(`${API_BASE_URL}/users/1/redemptions`)
}

// Helper to clear cache (for after mutations)
export function invalidateCache(url?: string) {
  if (url) {
    cache.delete(url)
  } else {
    cache.clear()
  }
}

// Mutation for redeeming rewards
export async function redeemReward(rewardId: number): Promise<void> {
  const response = await fetch(`${API_BASE_URL}/redemptions`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user_id: 1,
      reward_id: rewardId
    })
  })
  
  if (!response.ok) {
    const error = await response.json()
    throw new Error(error.error || 'Failed to redeem reward')
  }
  
  // Clear cache to trigger refetch of all data
  invalidateCache()
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