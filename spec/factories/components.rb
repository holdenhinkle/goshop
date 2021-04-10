FactoryBot.define do
  factory :component do
    name { Faker::Lorem.words(number: Random.new.rand(1..3)).join(' ') }
    description { Faker::Lorem.paragraph }
    min_quantity { 1 }
  end

  trait :no_name do 
    name { nil }
  end

  trait :no_description do
    description { nil }
  end

  trait :with_image do
    image { Faker::Internet.url(host: 'example.com') }
  end

  trait :with_max_quantity do
    max_quantity { 2 }
  end
end

# many to many relationship with options (simple products)
