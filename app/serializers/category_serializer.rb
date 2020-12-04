class CategorySerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name, :description, :image, :slug
end
