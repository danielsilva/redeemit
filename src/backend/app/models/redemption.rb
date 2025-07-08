class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_used, presence: true, numericality: { greater_than: 0 }
  validates :redeemed_at, presence: true
  validate :user_has_sufficient_points, on: :create
  validate :reward_is_available, on: :create

  before_validation :ensure_redeemed_at, on: :create

  def reward_name
    reward.name
  end

  private

  def ensure_redeemed_at
    self.redeemed_at ||= Time.current
  end

  def user_has_sufficient_points
    unless user.can_redeem?(reward)
      errors.add(:base, 'Insufficient points')
    end
  end

  def reward_is_available
    if reward.available_quantity <= 0
      errors.add(:base, 'Reward is out of stock')
    end
  end
end
