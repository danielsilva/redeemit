import React from 'react'

const Dashboard = ({ user }) => {
  if (!user) {
    return <div className="loading">Loading...</div>
  }

  return (
    <div className="dashboard">
      <div className="user-info">
        <h2>Welcome, {user.name}!</h2>
        <div className="points-balance">
          <h3>Your Points Balance</h3>
          <div className="balance-display">
            <span className="points-number">{user.points_balance}</span>
            <span className="points-label">points</span>
          </div>
        </div>
      </div>
      
      <div className="dashboard-actions">
        <div className="action-card">
          <h4>Browse Rewards</h4>
          <p>Discover available rewards you can redeem with your points</p>
        </div>
        <div className="action-card">
          <h4>Redemption History</h4>
          <p>View your past reward redemptions and track your activity</p>
        </div>
      </div>
    </div>
  )
}

export default Dashboard