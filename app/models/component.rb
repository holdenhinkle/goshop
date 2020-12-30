class Component < ApplicationRecord
  validates_presence_of :name, :description, :min_quantity
  validates :name, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_components
  has_many :products, through: :product_components
end