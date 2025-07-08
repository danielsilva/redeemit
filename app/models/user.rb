# Model representing a user who can redeem rewards
class User < ApplicationRecord
  has_many :redemptions, dependent: :destroy
  has_many :rewards, through: :redemptions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :points_balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def can_redeem?(reward)
    points_balance >= reward.points_cost
  end
end
