class ComponentProductOption < ApplicationRecord
  belongs_to :product
  belongs_to :component
end