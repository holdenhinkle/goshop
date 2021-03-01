require 'rails_helper'

RSpec.describe Api::V1::ComponentsController, type: :request do
  let!(:url) { 'http://localhost:3000/api/v1/components/' }

  describe '#index' do
    before do
      2.times { create(:component) }
      get(url)
    end

    it 'returns http status 200 OK' do
      expect(response).to have_http_status(200)
    end
  end
end