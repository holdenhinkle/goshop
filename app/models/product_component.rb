class ProductComponent < ApplicationRecord
  belongs_to :component
  belongs_to :composite
end