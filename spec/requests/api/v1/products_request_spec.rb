require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let!(:url) { 'http://localhost:3000/api/v1/products/' }

  context 'simple product' do
    # to-do:
    # test pricing => you can enter 999 or 9.99 and regularPriceCents will be 999

    describe '#index' do
      before do
        2.times { create(:simple_product) }
        get(url)
      end
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(200)
      end
  
      it "returns two product objects" do
        products = JSON.parse(response.body)['data']
        expect(products.count).to eq(2)
      end
  
      it 'renders the correct JSON representation of the existing products' do
        json_response = JSON.parse(response.body)

        json_response['data'].each do |product|
          expect(product.keys).to match_array(%w[id type attributes relationships])
          expect(product['type']).to eq('product')
          expect(product['attributes'].keys).to match_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount unitOfMeasure isVisible slug])
          expect(product['relationships'].keys).to match_array(%w[categories])
          expect(product['relationships']['categories'].keys).to match_array(%w[data])
  
          product['relationships']['categories']['data'].each do |data|
            expect(data.keys).to match_array(%w[id type])
            expect(data['type']).to eq('category')
          end
        end
      end
    end
  end

  context 'composite product' do
    context 'with component products' do
      
    end

    context 'without component products' do
      
    end
  end
end