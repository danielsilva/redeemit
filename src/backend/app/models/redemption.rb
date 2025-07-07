class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_used, presence: true, numericality: { greater_than: 0 }
  validates :redeemed_at, presence: true

  before_validation :ensure_redeemed_at, on: :create

  private

  def ensure_redeemed_at
    self.redeemed_at ||= Time.current
  end
end
