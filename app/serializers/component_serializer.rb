class ComponentSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name, :description, :image, :slug, :min_quantity, :max_quantity, :is_enabled
  has_many :product_options, serializer: ProductSerializer

  attribute :product_options do |object|
    object.product_options.as_json
  end
end