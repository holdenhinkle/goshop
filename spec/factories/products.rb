FactoryBot.define do
  factory :product do
    name { Faker::Lorem.words(number: Random.new.rand(1..3)).join(' ') }
    description { Faker::Lorem.paragraph }
    regular_price_cents { Faker::Number.between(from: 99, to: 20000) }
    unit_of_measure { 'piece' }
  end

  factory :simple_product_with_category_ids, parent: :product, class: Simple do
    type { 'Simple' }
    
    category_ids do
      [create(:category), create(:category)].each_with_object([]) do |category, array|
        array << category.id
      end
    end
  end

  factory :simple_product_with_categories_attributes, parent: :product, class: Simple do
    type { 'Simple' }
    categories_attributes { [attributes_for(:category)] }
  end

  factory :composite_product_with_component_ids, parent: :product, class: Composite do
    type { 'Composite' }

    category_ids do
      [create(:category), create(:category)].each_with_object([]) do 
        |category, array| array << category.id
      end
    end

    component_ids do
      [create(:component), create(:component)].each_with_object([]) do |component, array|
        array << component.id
      end
    end
  end

  factory :composite_product_with_components_attributes, parent: :product, class: Composite do
    type { 'Composite' }
    categories_attributes { [attributes_for(:category), attributes_for(:category)] }
    components_attributes { [attributes_for(:component)] }
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
