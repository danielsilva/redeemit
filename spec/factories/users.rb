# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "User #{n}" }
    points_balance { 1000 }

    trait :with_high_balance do
      points_balance { 5000 }
    end

    trait :with_low_balance do
      points_balance { 50 }
    end

    trait :with_no_points do
      points_balance { 0 }
    end
  end
end
