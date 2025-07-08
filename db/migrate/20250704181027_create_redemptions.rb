# Migration to create redemptions table
class CreateRedemptions < ActiveRecord::Migration[8.0]
  def change
    create_table :redemptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward, null: false, foreign_key: true
      t.integer :points_used, null: false
      t.datetime :redeemed_at, null: false

      t.timestamps
    end
  end
end
