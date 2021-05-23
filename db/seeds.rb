# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

1.upto(9999999) do |n|
  string = n.to_s
  tenant_id = ('0' * (7 - string.length)) + string
  AvailableTenantId.create(tenant_id: tenant_id)
end