
FactoryBot.define do
  factory :redemption do
    association :user
    association :reward
    points_used { 100 }
    redeemed_at { Time.current }

    trait :recent do
      redeemed_at { 1.hour.ago }
    end

    trait :old do
      redeemed_at { 1.month.ago }
    end

    trait :today do
      redeemed_at { Time.current.beginning_of_day }
    end

    trait :expensive_redemption do
      association :reward, :expensive
      points_used { reward.points_cost }
    end

    trait :cheap_redemption do
      association :reward, :cheap
      points_used { reward.points_cost }
    end
  end
end
