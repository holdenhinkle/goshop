class UserSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :email,
             :phone,
             :role,
             :first_name,
             :last_name,
end