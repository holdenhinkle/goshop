class Product < ApplicationRecord
  enum product_type: { 
    simple: 'simple',
    composite: 'composite',
    configured_composite: 'configured_composite'
  }, _prefix: :type

  validates_presence_of :name, :description, :product_type, :regular_price

  extend FriendlyId
  friendly_id :name, use: :slugged
end