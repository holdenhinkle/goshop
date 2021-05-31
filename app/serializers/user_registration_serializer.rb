class UserRegistrationSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :email,
             :role
end