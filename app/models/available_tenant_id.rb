class AvailableTenantId < ApplicationRecord
  validates :tenant_id, length: {minimum: 7, maximum: 7}, allow_blank: false
  validates :tenant_id, uniqueness: true
end