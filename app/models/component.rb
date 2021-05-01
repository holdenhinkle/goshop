class Component < ApplicationRecord
  acts_as_tenant :account
  
  validates_presence_of :name, :description, :min_quantity
  validates :name, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_components
  has_many :composite_products, through: :product_components, source: :composite

  has_many :component_product_options
  has_many :options, through: :component_product_options, source: :product
end