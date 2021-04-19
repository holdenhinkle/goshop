FactoryBot.define do
  factory :category do
    name do
      Array.new(Random.new.rand(1..3)).map do |word|
        Faker::Lorem.characters(number: Random.new.rand(3..6)).capitalize
      end.join(' ')
    end
    
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