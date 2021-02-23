class Composite < Product
  validates :components, presence: true

  has_many :product_components
  has_many :components, through: :product_components

  def components_attributes=(component_attributes)
    nested_attributes(nested_attributes: component_attributes,
                      model: Component,
                      collection: components)
  end
end