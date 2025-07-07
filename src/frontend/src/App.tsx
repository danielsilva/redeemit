import { useState, Suspense } from 'react'
import Dashboard from './components/Dashboard'
import RewardsList from './components/RewardsList'
import RedemptionHistory from './components/RedemptionHistory'
import Loading from './components/Loading'
import ErrorBoundary from './components/ErrorBoundary'
import { invalidateCache } from './hooks/useApi'
import type { ViewType } from './types'

function App() {
  const [currentView, setCurrentView] = useState<ViewType>('dashboard')

  const API_BASE_URL = 'http://localhost:3000/api'

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
        // Clear cache to trigger refetch
        invalidateCache()
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
        return <Dashboard />
      case 'rewards':
        return <RewardsList onRedeem={handleRedemption} />
      case 'history':
        return <RedemptionHistory />
      default:
        return <Dashboard />
    }
  }

  return (
    <div className="min-h-screen flex flex-col bg-gray-50">
      <header className="bg-slate-800 text-white shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold py-6">Redeemit!</h1>
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
        <ErrorBoundary>
          <Suspense fallback={<Loading />}>
            {renderCurrentView()}
          </Suspense>
        </ErrorBoundary>
      </main>
    </div>
  )
}

export default App
