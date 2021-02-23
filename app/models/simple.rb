class Simple < Product
  has_many :component_product_options
  has_many :component_options, through: :component_product_options, source: :component
end