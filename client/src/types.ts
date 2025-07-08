export type User = {
  id: number
  name: string
  points_balance: number
}

export type Reward = {
  id: number
  name: string
  description: string
  points_cost: number
  available_quantity: number
}

export type Redemption = {
  id: number
  reward_name: string
  points_used: number
  redeemed_at: string
}

export type ViewType = 'dashboard' | 'rewards' | 'history'