FactoryBot.define do
  factory :component do
    name do
      Array.new(Random.new.rand(1..3)).map do |word|
        Faker::Lorem.characters(number: Random.new.rand(3..6)).capitalize
      end.join(' ')
    end

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

  trait :with_option_ids do
    option_ids do
      [create(:simple_product_with_category_ids), create(:simple_product_with_category_ids)].each_with_object([]) do |product, array|
        array << product.id
      end
    end
  end

  trait :with_max_quantity do
    max_quantity { 2 }
  end

  trait :with_non_default_min_quantity do
    min_quantity { 2 }
  end

  trait :is_not_enabled do
    is_enabled { false }
  end
end
