import { useState, useEffect } from 'react'
import Dashboard from './components/Dashboard'
import RewardsList from './components/RewardsList'
import RedemptionHistory from './components/RedemptionHistory'

interface User {
  id: number
  name: string
  points_balance: number
}

interface Reward {
  id: number
  name: string
  description: string
  points_cost: number
  available_quantity: number
}

interface Redemption {
  id: number
  reward_name: string
  points_used: number
  redeemed_at: string
}

type ViewType = 'dashboard' | 'rewards' | 'history'

function App() {
  const [currentView, setCurrentView] = useState<ViewType>('dashboard')
  const [user, setUser] = useState<User | null>(null)
  const [rewards, setRewards] = useState<Reward[]>([])
  const [redemptions, setRedemptions] = useState<Redemption[]>([])

  const API_BASE_URL = 'http://localhost:3000/api'

  useEffect(() => {
    fetchUser()
    fetchRewards()
  }, [])

  const fetchUser = async (): Promise<void> => {
    try {
      const response = await fetch(`${API_BASE_URL}/users/1/balance`)
      const userData: User = await response.json()
      setUser(userData)
    } catch (error) {
      console.error('Error fetching user:', error)
    }
  }

  const fetchRewards = async (): Promise<void> => {
    try {
      const response = await fetch(`${API_BASE_URL}/rewards`)
      const rewardsData: Reward[] = await response.json()
      setRewards(rewardsData)
    } catch (error) {
      console.error('Error fetching rewards:', error)
    }
  }

  const fetchRedemptions = async (): Promise<void> => {
    try {
      const response = await fetch(`${API_BASE_URL}/users/1/redemptions`)
      const redemptionsData: Redemption[] = await response.json()
      setRedemptions(redemptionsData)
    } catch (error) {
      console.error('Error fetching redemptions:', error)
    }
  }

  const handleRedemption = async (rewardId: number): Promise<void> => {
    try {
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
      
      if (response.ok) {
        fetchUser()
        fetchRewards()
        alert('Reward redeemed successfully!')
      } else {
        const error = await response.json()
        alert(`Error: ${error.error}`)
      }
    } catch (error) {
      console.error('Error redeeming reward:', error)
    }
  }

  const renderCurrentView = () => {
    switch (currentView) {
      case 'dashboard':
        return <Dashboard user={user} />
      case 'rewards':
        return <RewardsList rewards={rewards} onRedeem={handleRedemption} />
      case 'history':
        return <RedemptionHistory redemptions={redemptions} onLoad={fetchRedemptions} />
      default:
        return <Dashboard user={user} />
    }
  }

  return (
    <div className="min-h-screen flex flex-col bg-gray-50">
      <header className="bg-slate-800 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold py-6">Rewards Redemption System</h1>
          <nav className="flex space-x-1 pb-6">
            <button 
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                currentView === 'dashboard' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-300 hover:bg-gray-700 hover:text-white'
              }`}
              onClick={() => setCurrentView('dashboard')}
            >
              Dashboard
            </button>
            <button 
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                currentView === 'rewards' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-300 hover:bg-gray-700 hover:text-white'
              }`}
              onClick={() => setCurrentView('rewards')}
            >
              Browse Rewards
            </button>
            <button 
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                currentView === 'history' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-300 hover:bg-gray-700 hover:text-white'
              }`}
              onClick={() => setCurrentView('history')}
            >
              My Redemptions
            </button>
          </nav>
        </div>
      </header>
      <main className="flex-1 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full">
        {renderCurrentView()}
      </main>
    </div>
  )
}

export default App
