import React from 'react'

const RewardsList = ({ rewards, onRedeem }) => {
  return (
    <div className="rewards-list">
      <h2>Available Rewards</h2>
      <div className="rewards-grid">
        {rewards.map(reward => (
          <div key={reward.id} className="reward-card">
            <div className="reward-header">
              <h3>{reward.name}</h3>
              <span className="points-cost">{reward.points_cost} points</span>
            </div>
            <div className="reward-body">
              <p className="reward-description">{reward.description}</p>
              <div className="reward-availability">
                <span className="availability-label">Available:</span>
                <span className="availability-count">{reward.available_quantity}</span>
              </div>
            </div>
            <div className="reward-footer">
              <button 
                className="redeem-btn"
                onClick={() => onRedeem(reward.id)}
                disabled={reward.available_quantity === 0}
              >
                {reward.available_quantity === 0 ? 'Out of Stock' : 'Redeem'}
              </button>
            </div>
          </div>
        ))}
      </div>
      {rewards.length === 0 && (
        <div className="no-rewards">
          <p>No rewards available at the moment.</p>
        </div>
      )}
    </div>
  )
}

export default RewardsList