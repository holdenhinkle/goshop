class ProductSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name,
             :description,
             :image,
             :type,
             :regular_price_cents,
             :sale_price_cents,
             :inventory_amount,
             :unit_of_measure,
             :is_visible,
             :slug

  has_many :categories
end
