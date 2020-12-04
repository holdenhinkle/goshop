class Category < ApplicationRecord
  validates_presence_of :name, :description

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :categories_products
  has_many :products, through: :categories_products
end