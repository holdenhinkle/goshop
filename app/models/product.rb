class Product < ApplicationRecord
  enum product_type: { 
    simple: 'simple',
    composite: 'composite',
    configured_composite: 'configured_composite'
  }, _prefix: :type

  monetize :regular_price_cents
  monetize :sale_price_cents, allow_nil: true

  validates_presence_of :name, :description, :product_type, :regular_price_cents
  validates :regular_price_cents, numericality: { greater_than: 0 }
  validate :simple_product_cannot_have_any_components,
    :composite_product_must_have_at_least_two_components

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :product_components
  has_many :components, through: :product_components

  def categories_attributes=(categories)
    categories.each do |category_attributes|
      name = category_attributes[:name]

      if category = Category.find_by(name: name)
        categories << category unless categories.map { |c| c[:name] }.include?(name)
      else
        categories << Category.create(category_attributes)
      end
    end
  end

  def components_attributes=(components)
    components.each do |component_attributes|
      name = component_attributes[:name]

      if component = Component.find_by(name: name)
        components << component unless components.map { |c| c[:name] }.include?(name)
      else
        components << Component.create(component_attributes)
      end
    end
  end

  def simple_product_cannot_have_any_components
    if product_type == 'simple' && components.present?
      errors.add(:simple_product, "can't have components")
    end
  end

  def composite_product_must_have_at_least_two_components
    if product_type == 'composite' && components.empty?
      errors.add(:composite_product, "must have at least two components")
    end
  end
end