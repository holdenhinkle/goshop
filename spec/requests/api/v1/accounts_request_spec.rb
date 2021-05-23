require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :request do
  tenant_id = '1234567' # to-do: create account and grab tenant_id
  let!(:url) { `http://localhost:3000/#{tenant_id}api/v1/admin/accounts/` }
end