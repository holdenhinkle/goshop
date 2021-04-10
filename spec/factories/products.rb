FactoryBot.define do
  factory :product do
    name { Faker::Lorem.unique.words(number: Random.new.rand(1..3)).join(' ') }
    description { Faker::Lorem.paragraph }
    regular_price_cents { Faker::Number.between(from: 99, to: 20000) }
    category_ids do
      [create(:category), create(:category)].each_with_object([]) { |category, array| array << category.id }
    end
    unit_of_measure { 'piece' }
  end

  factory :simple_product, parent: :product, class: Simple do
    type { 'Simple' }
  end

  trait :product_no_name do
    name { nil }
  end

  trait :product_no_description do
    description { nil }
  end

  trait :product_no_regular_price do
    regular_price_cents { nil }
  end

  trait :product_no_unit_of_measure do
    unit_of_measure { nil }
  end

  # a bad enum value throws an ArgumentError
  # fix this later
  # return an error instead of throwing an error
  trait :product_invalid_unit_of_measure_value do
    unit_of_measure { 'bad_value' }
  end

  trait :product_with_image do
    image { Faker::Internet.url(host: 'example.com') }
  end

  trait :product_with_sale_price_cents do
    sale_price_cents { Faker::Number.between(from: 99, to: 20000) }
  end

  trait :product_with_inventory_amount do
    inventory_amount { Faker::Number.between(from: 0, to: 100) } 
  end

  trait :product_is_not_visible do
    is_visible { false }
  end
end
