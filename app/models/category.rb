class Category < ApplicationRecord
  validates_presence_of :name, :description

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :products, through: :product_categories
end