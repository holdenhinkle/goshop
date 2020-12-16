class Component < ApplicationRecord
  validates_presence_of :name, :description, :min_quantity

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :components_products
  has_many :products, through: :components_products
end