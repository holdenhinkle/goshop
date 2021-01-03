class ProductOptionSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name,
             :description,
             :image,
             :product_type,
             :regular_price_cents,
             :sale_price_cents,
             :inventory_amount,
             :slug

  has_many :components
end
