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