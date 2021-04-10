FactoryBot.define do
  factory :category do
    name { Faker::Lorem.unique.word }
    description { Faker::Lorem.paragraph }

    trait :no_name do
      name { nil }
    end

    trait :no_description do
      description { nil }
    end

    trait :with_image do
      image { Faker::Internet.url(host: 'example.com') }
    end
  end
end