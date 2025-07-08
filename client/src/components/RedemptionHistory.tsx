import React from 'react'
import { useRedemptions } from '../hooks/useApi'

const RedemptionHistory: React.FC = () => {
  const redemptions = useRedemptions()

  const formatDate = (dateString: string): string => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gray-800">Your Redemption History</h2>
      
      {redemptions.length === 0 ? (
        <div className="text-center py-12 bg-white rounded-lg shadow-md">
          <div className="text-gray-500 space-y-2">
            <p className="text-lg">You haven't redeemed any rewards yet.</p>
            <p>Browse available rewards to start earning!</p>
          </div>
        </div>
      ) : (
        <div className="space-y-4">
          {redemptions.map(redemption => (
            <div key={redemption.id} className="bg-white rounded-lg shadow-md border border-gray-200 p-6 flex justify-between items-center" data-testid="redemption-row">
              <div className="flex-1">
                <h3 className="text-lg font-semibold text-gray-800 mb-1">{redemption.reward_name}</h3>
                <p className="text-sm text-gray-500" data-testid="redeemed-at">{formatDate(redemption.redeemed_at)}</p>
              </div>
              <div className="text-right">
                <span className="text-lg font-bold text-red-600" data-testid="points-used">-{redemption.points_used} points</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default RedemptionHistory