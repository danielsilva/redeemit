# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create test users
User.find_or_create_by!(email: 'john@example.com') do |user|
  user.name = 'John Doe'
  user.points_balance = 1000
end

User.find_or_create_by!(email: 'jane@example.com') do |user|
  user.name = 'Jane Smith'
  user.points_balance = 1500
end

# Create test rewards
Reward.find_or_create_by!(name: 'Coffee Voucher') do |reward|
  reward.description = 'Free coffee at our partner cafes'
  reward.points_cost = 100
  reward.available_quantity = 50
end

Reward.find_or_create_by!(name: 'Movie Ticket') do |reward|
  reward.description = 'Free movie ticket at participating theaters'
  reward.points_cost = 250
  reward.available_quantity = 30
end

Reward.find_or_create_by!(name: 'Gift Card $10') do |reward|
  reward.description = '$10 gift card for popular stores'
  reward.points_cost = 400
  reward.available_quantity = 20
end

Reward.find_or_create_by!(name: 'Premium Subscription') do |reward|
  reward.description = '1 month premium subscription'
  reward.points_cost = 800
  reward.available_quantity = 10
end
