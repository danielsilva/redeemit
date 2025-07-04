import React from 'react'

const Dashboard = ({ user }) => {
  if (!user) {
    return (
      <div className="flex justify-center items-center py-12">
        <div className="text-xl text-gray-600">Loading...</div>
      </div>
    )
  }

  return (
    <div className="space-y-8">
      <div className="bg-white rounded-lg shadow-md p-8 text-center">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Welcome, {user.name}!</h2>
        <div className="mt-6">
          <h3 className="text-lg font-semibold text-gray-700 mb-2">Your Points Balance</h3>
          <div className="flex items-center justify-center space-x-2 mt-4">
            <span className="text-5xl font-bold text-blue-600">{user.points_balance}</span>
            <span className="text-xl text-gray-500">points</span>
          </div>
        </div>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-md p-6 text-center border border-gray-200 hover:shadow-lg transition-shadow">
          <h4 className="text-lg font-semibold text-gray-800 mb-2">Browse Rewards</h4>
          <p className="text-gray-600">Discover available rewards you can redeem with your points</p>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6 text-center border border-gray-200 hover:shadow-lg transition-shadow">
          <h4 className="text-lg font-semibold text-gray-800 mb-2">Redemption History</h4>
          <p className="text-gray-600">View your past reward redemptions and track your activity</p>
        </div>
      </div>
    </div>
  )
}

export default Dashboard