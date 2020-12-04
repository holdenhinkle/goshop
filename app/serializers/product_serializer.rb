class ProductSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name, :description, :image, :product_type, :regular_price, :sale_price, :inventory_amount
end
