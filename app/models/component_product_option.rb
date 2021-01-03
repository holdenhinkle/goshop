class ComponentProductOption < ApplicationRecord
  validates :component_id, uniqueness: { scope: :product_id }

  belongs_to :component
  belongs_to :product
end