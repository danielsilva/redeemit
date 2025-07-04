import React from 'react'

interface Reward {
  id: number
  name: string
  description: string
  points_cost: number
  available_quantity: number
}

interface RewardsListProps {
  rewards: Reward[]
  onRedeem: (rewardId: number) => void
}

const RewardsList: React.FC<RewardsListProps> = ({ rewards, onRedeem }) => {
  return (
    <div className="space-y-6">
      <h2 className="text-2xl font-bold text-gray-800">Available Rewards</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {rewards.map(reward => (
          <div key={reward.id} className="bg-white rounded-lg shadow-md border border-gray-200 hover:shadow-lg transition-shadow">
            <div className="p-6">
              <div className="flex justify-between items-start mb-4">
                <h3 className="text-lg font-semibold text-gray-800">{reward.name}</h3>
                <span className="bg-blue-600 text-white px-3 py-1 rounded-full text-sm font-medium">
                  {reward.points_cost} points
                </span>
              </div>
              <div className="space-y-4">
                <p className="text-gray-600">{reward.description}</p>
                <div className="flex justify-between items-center text-sm">
                  <span className="text-gray-500">Available:</span>
                  <span className="font-medium text-green-600">{reward.available_quantity}</span>
                </div>
              </div>
              <div className="mt-6 flex justify-center">
                <button 
                  className={`px-6 py-3 rounded-lg font-medium transition-colors ${
                    reward.available_quantity === 0 
                      ? 'bg-gray-300 text-gray-500 cursor-not-allowed' 
                      : 'bg-green-600 text-white hover:bg-green-700'
                  }`}
                  onClick={() => onRedeem(reward.id)}
                  disabled={reward.available_quantity === 0}
                >
                  {reward.available_quantity === 0 ? 'Out of Stock' : 'Redeem'}
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
      {rewards.length === 0 && (
        <div className="text-center py-12">
          <div className="text-gray-500 text-lg">No rewards available at the moment.</div>
        </div>
      )}
    </div>
  )
}

export default RewardsList