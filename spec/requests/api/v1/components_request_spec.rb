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

    it "returns two component objects" do
      components = JSON.parse(response.body)['data']
      expect(components.count).to eq(2)
    end

    it 'renders the correct JSON representation of the existing components' do
      json_response = JSON.parse(response.body)

      json_response['data'].each do |component|
        expect(component.keys).to match_array(%w[id type attributes relationships])
        expect(component['type']).to eq('component')
        expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
        expect(component['relationships'].keys).to match_array(%w[options])
        expect(component['relationships']['options'].keys).to match_array(%w[data])

        component['relationships']['options']['data'].each do |data|
          expect(data.keys).to match_array(%w[id type])
          expect(data['type']).to eq('product')
        end
      end
    end
  end
end