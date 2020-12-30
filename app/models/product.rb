require 'pry'

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

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :product_components
  has_many :components, through: :product_components

  def categories_attributes=(categories)
    categories.each do |category_attributes|
      if category = Category.find_by(name: category_attributes[:name])
        self.categories << category unless self.categories.map { |c| c[:name] }.include? category_attributes[:name]
      else
        self.categories << Category.create(category_attributes)
      end
    end
  end
end