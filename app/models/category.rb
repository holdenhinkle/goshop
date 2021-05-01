class Category < ApplicationRecord
  acts_as_tenant :account

  validates_presence_of :name, :description
  validates_uniqueness_to_tenant :name

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :products, through: :product_categories
end