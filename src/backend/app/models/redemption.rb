class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_used, presence: true, numericality: { greater_than: 0 }
  validates :redeemed_at, presence: true

  before_create :set_redeemed_at

  private

  def set_redeemed_at
    self.redeemed_at = Time.current
  end
end
