import { useState, useEffect } from 'react'
import './App.css'
import Dashboard from './components/Dashboard'
import RewardsList from './components/RewardsList'
import RedemptionHistory from './components/RedemptionHistory'

function App() {
  const [currentView, setCurrentView] = useState('dashboard')
  const [user, setUser] = useState(null)
  const [rewards, setRewards] = useState([])
  const [redemptions, setRedemptions] = useState([])

  const API_BASE_URL = 'http://localhost:3000/api'

  useEffect(() => {
    fetchUser()
    fetchRewards()
  }, [])

  const fetchUser = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/users/1/balance`)
      const userData = await response.json()
      setUser(userData)
    } catch (error) {
      console.error('Error fetching user:', error)
    }
  }

  const fetchRewards = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/rewards`)
      const rewardsData = await response.json()
      setRewards(rewardsData)
    } catch (error) {
      console.error('Error fetching rewards:', error)
    }
  }

  const fetchRedemptions = async () => {
    try {
      const response = await fetch(`${API_BASE_URL}/users/1/redemptions`)
      const redemptionsData = await response.json()
      setRedemptions(redemptionsData)
    } catch (error) {
      console.error('Error fetching redemptions:', error)
    }
  }

  const handleRedemption = async (rewardId) => {
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
    <div className="app">
      <header className="app-header">
        <h1>Rewards Redemption System</h1>
        <nav>
          <button 
            className={currentView === 'dashboard' ? 'active' : ''}
            onClick={() => setCurrentView('dashboard')}
          >
            Dashboard
          </button>
          <button 
            className={currentView === 'rewards' ? 'active' : ''}
            onClick={() => setCurrentView('rewards')}
          >
            Browse Rewards
          </button>
          <button 
            className={currentView === 'history' ? 'active' : ''}
            onClick={() => setCurrentView('history')}
          >
            My Redemptions
          </button>
        </nav>
      </header>
      <main className="app-main">
        {renderCurrentView()}
      </main>
    </div>
  )
}

export default App
