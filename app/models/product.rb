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

  has_many :categories_products
  has_many :categories, through: :categories_products

  has_many :components_products
  has_many :components, through: :components_products
end