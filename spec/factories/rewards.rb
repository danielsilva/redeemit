# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n}" }
    sequence(:description) { |n| "Description for reward #{n}" }
    points_cost { 100 }
    available_quantity { 10 }

    trait :expensive do
      points_cost { 1000 }
    end

    trait :cheap do
      points_cost { 50 }
    end

    trait :out_of_stock do
      available_quantity { 0 }
    end

    trait :limited_stock do
      available_quantity { 1 }
    end

    trait :popular do
      name { 'Popular Reward' }
      description { 'A very popular reward that everyone wants' }
      points_cost { 250 }
      available_quantity { 5 }
    end
  end
end
