# frozen_string_literal: true

# Migration to create rewards table
class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :points_cost, null: false
      t.integer :available_quantity, null: false

      t.timestamps
    end
  end
end
