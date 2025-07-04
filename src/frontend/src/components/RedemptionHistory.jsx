import React, { useEffect } from 'react'

const RedemptionHistory = ({ redemptions, onLoad }) => {
  useEffect(() => {
    onLoad()
  }, [onLoad])

  const formatDate = (dateString) => {
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
    <div className="redemption-history">
      <h2>Your Redemption History</h2>
      
      {redemptions.length === 0 ? (
        <div className="no-redemptions">
          <p>You haven't redeemed any rewards yet.</p>
          <p>Browse available rewards to start earning!</p>
        </div>
      ) : (
        <div className="redemptions-list">
          {redemptions.map(redemption => (
            <div key={redemption.id} className="redemption-item">
              <div className="redemption-info">
                <h3>{redemption.reward_name}</h3>
                <p className="redemption-date">{formatDate(redemption.redeemed_at)}</p>
              </div>
              <div className="redemption-points">
                <span className="points-used">-{redemption.points_used} points</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default RedemptionHistory