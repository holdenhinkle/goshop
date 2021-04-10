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

    describe '#show' do
      let!(:product) { create(:simple_product) }
    
      it 'renders the correct JSON representation of the product' do
        id = product.id.to_s
        get(url + id)
    
        product = JSON.parse(response.body)['data']
        categories = JSON.parse(response.body)['included']
    
        expect(product.keys).to match_array(%w[id type attributes relationships])
        expect(product['type']).to eq('product')
        expect(product['attributes'].keys).to match_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount unitOfMeasure isVisible slug])
        expect(product['relationships'].keys).to match_array(%w[categories])
        expect(product['relationships']['categories'].keys).to match_array(%w[data])
    
        categories.each do |category|
          expect(category.keys).to match_array(%w[id type attributes])
          expect(category['type']).to eq('category')
          expect(category['attributes'].keys).to match_array(%w[name description image slug])
        end
      end
    
      context 'using product id is used as identifying param' do
        let!(:id) { product.id.to_s }
        
        it 'returns http status 200 OK' do
          get(url + id)
          expect(response).to have_http_status(200)
        end
    
        it 'returns expected product' do
          get(url + id)
          body = JSON.parse(response.body)
          expect(body['data']['type']).to eq('product')
          expect(body['data']['id']).to eq(id)
        end
    
        context "when product doesn't exist" do
          let!(:bad_id) { (id.to_i + 1).to_s }
    
          it 'returns an error' do
            get(url + bad_id)
            body = JSON.parse(response.body)
            expect(body['error']).to eq("The requested product doesn't exist")
          end
    
          it 'returns a 404 status code' do
            get(url + bad_id)
            expect(response).to have_http_status(404)
          end
        end
      end
    
      context 'using product slug is used as identifying param' do
        let!(:slug) { product.slug }
    
        it 'returns http status 200 OK' do
          get(url + slug)
          expect(response).to have_http_status(200)
        end
    
        it 'returns expected product' do
          get(url + slug)
          body = JSON.parse(response.body)
          expect(body['data']['type']).to eq('product')
          expect(body['data']['attributes']['slug']).to eq(slug)
        end
    
        context "when product doesn't exist" do
          let!(:bad_slug) { (slug + slug) }
    
          it 'returns an error when product does not exist' do
          get(url + bad_slug)
            body = JSON.parse(response.body)
            expect(body['error']).to eq("The requested product doesn't exist")
          end
    
          it 'returns a 404 status code when product does not exist' do
          get(url + bad_slug)
            expect(response).to have_http_status(404)
          end
        end
      end
    end    

    describe '#create' do
      context 'valid request with only required attributes' do
        before do
          product_attributes = attributes_for(:simple_product)
          post(url, params: { product: product_attributes })
        end
    
        it 'returns 200' do
          expect(response).to have_http_status(:success)
        end
    
        it 'renders the correct JSON representation of the new component' do
          product = JSON.parse(response.body)['data']
    
          expect(product.keys).to match_array(%w[id type attributes relationships])
          expect(product['type']).to eq('product')
          expect(product['attributes'].keys).to match_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount unitOfMeasure isVisible slug])
          expect(product['relationships'].keys).to match_array(%w[categories])
          expect(product['relationships']['categories'].keys).to match_array(%w[data])
    
          product['relationships']['categories']['data'].each do |category|
            expect(category.keys).to match_array(%w[id type])
            expect(category['type']).to eq('category')           
          end
        end
    
        it 'sets image to nil' do
          expect(JSON.parse(response.body)['data']['attributes']['image']).to be(nil)
        end
    
        it 'sets sale_price_cents to nil' do
          expect(JSON.parse(response.body)['data']['attributes']['salePriceCents']).to be(nil)          
        end
    
        it 'sets inventory to nil' do
          expect(JSON.parse(response.body)['data']['attributes']['inventoryAmount']).to be(nil)        
        end
    
        it 'sets is_visible to true' do
          expect(JSON.parse(response.body)['data']['attributes']['isVisible']).to be(true)        
        end
      end
    
      context 'valid request with optional attributes' do
        fit 'sets image to given value' do
          product_attributes = attributes_for(:simple_product, :product_with_image)
          post(url, params: { product: product_attributes })
          expect(JSON.parse(response.body)['data']['attributes']['image']).not_to be(nil)
        end
    
        it 'sets sale_price_cents to given value' do
          product_attributes = attributes_for(:simple_product, :product_with_sale_price_cents)
          post(url, params: { product: product_attributes })
          expect(JSON.parse(response.body)['data']['attributes']['salePriceCents']).not_to be(nil)          
        end
    
        it 'sets inventory_amount to given value' do
          product_attributes = attributes_for(:simple_product, :product_with_inventory_amount)
          post(url, params: { product: product_attributes })
          expect(JSON.parse(response.body)['data']['attributes']['inventoryAmount']).not_to be(nil)          
        end
    
        it 'sets is_visible to given value' do
          product_attributes = attributes_for(:simple_product, :product_is_not_visible)
          post(url, params: { product: product_attributes })
          expect(JSON.parse(response.body)['data']['attributes']['isVisible']).to be(false)                   
        end
      end
    
      context 'invalid request' do
        context 'name attribute is missing' do
          before do
            product_attributes = attributes_for(:simple_product, :product_no_name)
            post(url, params: { product: product_attributes })
          end
    
          it 'returns http status 422' do
            expect(response).to have_http_status(422)  
          end
    
          it 'returns the correct errror message' do
            body = JSON.parse(response.body)
            expect(body['errors'].count).to eq(1)
            expect(body['errors']['name'].count).to eq(1)
            expect(body['errors']['name'][0]).to eq("can't be blank")         
          end
        end
    
        context 'description attribute is missing' do
          before do
            product_attributes = attributes_for(:simple_product, :product_no_description)
            post(url, params: { product: product_attributes })
          end
    
          it 'returns http status 422' do
            expect(response).to have_http_status(422)
          end
    
          it 'returns the correct errror message' do
            body = JSON.parse(response.body)
            expect(body['errors'].count).to eq(1)
            expect(body['errors']['description'].count).to eq(1)
            expect(body['errors']['description'][0]).to eq("can't be blank")         
          end
        end
    
        context 'regular price attribute is missing' do
          before do
            product_attributes = attributes_for(:simple_product, :product_no_regular_price)
            post(url, params: { product: product_attributes })
          end
    
          it 'returns http status 422' do
            expect(response).to have_http_status(422)
          end
    
          it 'returns the correct errror message' do
            body = JSON.parse(response.body)
            expect(body['errors'].count).to eq(2)
            expect(body['errors']['regular_price_cents'].count).to eq(2)
            expect(body['errors']['regular_price_cents'][0]).to eq('is not a number')
            expect(body['errors']['regular_price_cents'][1]).to eq("can't be blank")
            expect(body['errors']['regular_price'].count).to eq(1)
            expect(body['errors']['regular_price'][0]).to eq('is not a number')
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