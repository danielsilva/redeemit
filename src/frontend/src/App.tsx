import { useState, Suspense } from 'react'
import Dashboard from './components/Dashboard'
import RewardsList from './components/RewardsList'
import RedemptionHistory from './components/RedemptionHistory'
import Loading from './components/Loading'
import ErrorBoundary from './components/ErrorBoundary'
import { useRedeemReward } from './hooks/useApi'
import type { ViewType } from './types'

function App() {
  const [currentView, setCurrentView] = useState<ViewType>('dashboard')
  const { redeemReward } = useRedeemReward()

  const handleRedemption = async (rewardId: number): Promise<void> => {
    const result = await redeemReward(rewardId)
    
    if (result.success) {
      alert('Reward redeemed successfully!')
    } else {
      console.error('Error redeeming reward:', result.error)
      alert(`Error: ${result.error}`)
    }
  }

  const renderCurrentView = () => {
    switch (currentView) {
      case 'dashboard':
        return <Dashboard onNavigate={setCurrentView} />
      case 'rewards':
        return <RewardsList onRedeem={handleRedemption} />
      case 'history':
        return <RedemptionHistory />
      default:
        return <Dashboard onNavigate={setCurrentView} />
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
