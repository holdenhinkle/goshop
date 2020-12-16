class Component < ApplicationRecord
  validates_presence_of :name, :description, :min_quantity

  extend FriendlyId
  friendly_id :name, use: :slugged
end