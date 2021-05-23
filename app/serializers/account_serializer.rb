class AccountSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :name,
             :tenant_id
end
