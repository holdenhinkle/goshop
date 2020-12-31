class ComponentProduct < ApplicationRecord
  belongs_to :product
  belongs_to :component
end