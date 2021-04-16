require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  let!(:url) { 'http://localhost:3000/api/v1/products/' }

  describe '#create' do
    context 'valid request with only required attributes' do
      context 'required category added by category_ids attribute' do
        before do
          product_attributes = attributes_for(:simple_product_with_category_ids)
          post(url, params: { product: product_attributes })
        end
    
        it 'returns 200' do
          expect(response).to have_http_status(:success)
        end
    
        it 'renders the correct JSON representation of the new product' do
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

      context 'required category added by categories_attributes attribute' do
        before do
          product_attributes = attributes_for(:simple_product_with_categories_attributes)
          post(url, params: { product: product_attributes })
        end
    
        it 'returns 200' do
          expect(response).to have_http_status(:success)
        end
    
        it 'renders the correct JSON representation of the new product' do
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
    end
  
    context 'valid request with optional attributes' do
      fit 'sets image to given value' do
        product_attributes = attributes_for(:simple_product_with_category_ids, :product_with_image)
        post(url, params: { product: product_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['image']).not_to be(nil)
      end
  
      it 'sets sale_price_cents to given value' do
        product_attributes = attributes_for(:simple_product_with_category_ids, :product_with_sale_price_cents)
        post(url, params: { product: product_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['salePriceCents']).not_to be(nil)          
      end
  
      it 'sets inventory_amount to given value' do
        product_attributes = attributes_for(:simple_product_with_category_ids, :product_with_inventory_amount)
        post(url, params: { product: product_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['inventoryAmount']).not_to be(nil)          
      end
  
      it 'sets is_visible to given value' do
        product_attributes = attributes_for(:simple_product_with_category_ids, :product_is_not_visible)
        post(url, params: { product: product_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['isVisible']).to be(false)                   
      end
    end
  
    context 'invalid request' do
      context 'name attribute is missing' do
        before do
          product_attributes = attributes_for(:simple_product_with_category_ids, :product_no_name)
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
          product_attributes = attributes_for(:simple_product_with_category_ids, :product_no_description)
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
  
      context 'regular_price_cents attribute is missing' do
        before do
          product_attributes = attributes_for(:simple_product_with_category_ids, :product_no_regular_price)
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

      context 'unit_of_measure attribute is missing' do
        before do
          product_attributes = attributes_for(:simple_product_with_category_ids, :product_no_unit_of_measure)
          post(url, params: { product: product_attributes })
        end
  
        it 'returns http status 422' do
          expect(response).to have_http_status(422)
        end
  
        it 'returns the correct errror message' do
          body = JSON.parse(response.body)
          expect(body['errors'].count).to eq(1)
          expect(body['errors']['unit_of_measure'].count).to eq(1)
          expect(body['errors']['unit_of_measure'][0]).to eq("can't be blank")
        end
      end

      # a bad enum value throws an ArgumentError
      # fix this later
      # return an error instead of throwing an error
      # this has been an open issue in the rails community for many years
      # consider fixing this
      skip 'unit_of_measure value is invalid' do
        before do
          product_attributes = attributes_for(:simple_product_with_category_ids, :product_invalid_unit_of_measure_value)
          post(url, params: { product: product_attributes })
        end
  
        it 'returns http status 422' do
          expect(response).to have_http_status(422)
        end
  
        it 'returns the correct errror message' do
          body = JSON.parse(response.body)
          expect(body['errors'].count).to eq(1)
          expect(body['errors']['unit_of_measure'].count).to eq(1)
          expect(body['errors']['unit_of_measure'][0]).to eq("can't be blank")
        end
      end
    end
  end

  describe '#update' do
    context 'name update' do
      let!(:original_name) { Faker::Lorem.words(number: 2).map(&:capitalize).join(' ') }
      let!(:new_name) { 'Updated Name' }
  
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids, name: original_name)
        post(url, params: { product: product_attributes })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { product: { name: new_name } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the name' do
        patch(url + @id, params: { product: { name: new_name } })
        current_name = JSON.parse(response.body)['data']['attributes']['name']
        expect(current_name).not_to eq(original_name)
        expect(current_name).to eq(new_name)
      end
  
      it 'updates the slug when the name is updated' do
        original_slug = JSON.parse(response.body)['data']['attributes']['slug']
        new_slug = new_name.split(' ').map(&:downcase).join('-')
        patch(url + @id, params: { product: { name: new_name } })
        current_slug = JSON.parse(response.body)['data']['attributes']['slug']
        expect(current_slug).not_to eq(original_slug)
        expect(current_slug).to eq(new_slug)
      end
    end
  
    context 'description update' do
      let!(:original_description) { Faker::Lorem.paragraph }
      let!(:new_description) { Faker::Lorem.paragraph }
  
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids, description: original_description)
        post(url, params: { product: product_attributes })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { product: { description: new_description } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        patch(url + @id, params: { product: { description: new_description } })
        current_description = JSON.parse(response.body)['data']['attributes']['description']
        expect(current_description).not_to eq(original_description)
        expect(current_description).to eq(new_description)
      end
    end
  
    context 'image update' do
      let!(:original_image) { Faker::Internet.url(host: 'example.com') }
      let!(:new_image) { Faker::Internet.url(host: 'example.com') }
  
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids, :with_image, image: original_image)
        post(url, params: { product: product_attributes })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { product: { image: new_image } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        patch(url + @id, params: { product: { image: new_image } })
        current_image = JSON.parse(response.body)['data']['attributes']['image']
        expect(current_image).not_to eq(original_image)
        expect(current_image).to eq(new_image)
      end
    end
  
    context 'regular price update' do
      let!(:original_price) { Faker::Number.between(from: 99, to: 20000) }
      let!(:new_price) { Faker::Number.between(from: 99, to: 20000) }
  
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids, regular_price_cents: original_price)
        post(url, params: { product: product_attributes })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { product: { regular_price_cents: new_price } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        patch(url + @id, params: { product: { regular_price_cents: new_price } })
        current_price = JSON.parse(response.body)['data']['attributes']['regularPriceCents']
        expect(current_price).not_to eq(original_price)
        expect(current_price).to eq(new_price)
      end
    end

    context 'add a category using category_ids param' do
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids)
        post(url, params: { product: product_attributes })
        body = JSON.parse(response.body)
        id = body['data']['id'].to_s
        @category_id_1 = body['included'][0]['id']
        @category_id_2 = body['included'][1]['id']
        @category_id_3 = create(:category)['id'].to_s
        patch(url + id, params: { product: { category_ids: [@category_id_1, @category_id_2, @category_id_3] } })
      end
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct categories' do
        categories = JSON.parse(response.body)['included']
        expect(categories.count).to eq(3)
        expect(categories[0]['id']).to eq(@category_id_1)
        expect(categories[1]['id']).to eq(@category_id_2)
        expect(categories[2]['id']).to eq(@category_id_3)
      end
    end

    context 'add a category using categories_attributes param' do
      before do
        product_attributes = attributes_for(:simple_product_with_categories_attributes)
        post(url, params: { product: product_attributes })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { product: { categories_attributes: [attributes_for(:category)] } })
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct categories' do
        expect(JSON.parse(response.body)['included'].count).to eq(1)
        patch(url + @id, params: { product: { categories_attributes: [attributes_for(:category)] } })
        expect(JSON.parse(response.body)['included'].count).to eq(2)
      end
    end

    context 'add a category that was already added using category_ids param' do
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids)
        post(url, params: { product: product_attributes })
        body = JSON.parse(response.body)
        id = body['data']['id'].to_s
        @category_id_1 = body['included'][0]['id']
        @category_id_2 = body['included'][1]['id']
        patch(url + id, params: { product: { category_ids: [@category_id_1, @category_id_1, @category_id_2] } })
      end
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct categories' do
        categories = JSON.parse(response.body)['included']
        expect(categories.count).to eq(2)
        expect(categories[0]['id']).to eq(@category_id_1)
        expect(categories[1]['id']).to eq(@category_id_2)
      end
    end

    context 'add a category that was already added using the categories_attributes param' do
      let!(:new_category) { create(:category) }

      before do
        post(url, params: { product: attributes_for(:simple_product_with_category_ids) })
        id = JSON.parse(response.body)['data']['id'].to_s
        patch(url + id, params: { product: { categories_attributes: [attributes_for(:category, name: new_category.name)] } })
      end

      it 'returns http status 200 OK' do
        expect(response).to have_http_status(:success)
      end
  
      it 'sets relationship with existing category with the same name' do
        categories = JSON.parse(response.body)['included']
        expect(categories.count).to eq(3)
        expect(categories[2]['id']).to eq(new_category.id.to_s)
        expect(categories[2]['attributes']['name']).to eq(new_category.name)
      end
    end

    # the following returns an ActiveRecord::RecordNotFound error
    # fix this later
    skip 'add a category that does not exist using category_ids param' do
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids)
        post(url, params: { product: product_attributes })
        body = JSON.parse(response.body)
        id = body['data']['id'].to_s
        @category_id_1 = body['included'][0]['id']
        @category_id_2 = body['included'][1]['id']
        @category_id_3 = (Category.last.id.to_i + 1).to_s
        patch(url + id, params: { product: { category_ids: [@category_id_1, @category_id_2, @category_id_3] } })
      end
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct categories' do
        categories = JSON.parse(response.body)['included']
        expect(categories.count).to eq(2)
        expect(categories[0]['id']).to eq(@category_id_1)
        expect(categories[1]['id']).to eq(@category_id_2)
      end
    end

    context 'remove a category using category_ids param' do
      before do
        product_attributes = attributes_for(:simple_product_with_category_ids)
        post(url, params: { product: product_attributes })
        body = JSON.parse(response.body)
        id = body['data']['id'].to_s
        @category_1_id = body['included'][0]['id']
        @category_2_id = body['included'][1]['id']
        patch(url + id, params: { product: { category_ids: [@category_1_id] } })
      end
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct category' do
        categories = JSON.parse(response.body)['included']
        expect(categories.count).to eq(1)
        expect(categories[0]['id']).to eq(@category_1_id)
        expect(categories[0]['id']).to_not eq(@category_2_id)
      end
    end
  end
end
