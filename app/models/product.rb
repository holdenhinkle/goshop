class Product < ApplicationRecord
  enum product_type: { 
    simple: 'simple',
    composite: 'composite',
    configured_composite: 'configured_composite'
  }, _prefix: :type

  monetize :regular_price_cents
  monetize :sale_price_cents, allow_nil: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :product_components
  has_many :components, through: :product_components

  has_many :component_product_options
  has_many :component_options, through: :component_product_options, source: :component

  validates_presence_of :name, :description, :product_type, :regular_price_cents, :categories
  validates :name, uniqueness: true
  validates :components, absence: true, if: :simple_product?
  validates :components, presence: true, if: :component_product?
  validates :regular_price_cents, numericality: { greater_than: 0 }

  def categories_attributes=(category_attributes)
    category_attributes.each do |attributes|
      name = attributes[:name]

      if category = Category.find_by(name: name)
        self.categories << category unless self.categories.map { |c| c[:name] }.include?(name)
      else
        self.categories << Category.create(attributes)
      end
    end
  end

  def components_attributes=(component_attributes)
    component_attributes.each do |attributes|
      name = attributes[:name]

      if component = Component.find_by(name: name)
        self.components << component unless self.components.map { |c| c[:name] }.include?(name)
      else
        component = Component.create(attributes)
        self.components << component
      end
    end
  end

  private

  def simple_product?
    self.product_type == 'simple'
  end

  def component_product?
    self.product_type == 'composite'
  end
end