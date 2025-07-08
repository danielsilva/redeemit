# Model representing a reward that can be redeemed with points
class Reward < ApplicationRecord
  has_many :redemptions, dependent: :destroy
  has_many :users, through: :redemptions

  validates :name, presence: true
  validates :description, presence: true
  validates :points_cost, presence: true, numericality: { greater_than: 0 }
  validates :available_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :available, -> { where('available_quantity > 0') }
end
