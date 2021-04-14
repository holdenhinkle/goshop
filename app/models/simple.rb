class Simple < Product
  # component_options is an array of simple product options for a component
  has_many :component_product_options
  has_many :component_options, through: :component_product_options, source: :component
end
