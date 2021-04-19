require 'rails_helper'

RSpec.describe Api::V1::ComponentsController, type: :request do
  let!(:url) { 'http://localhost:3000/api/v1/components/' }

  describe '#index' do
    before do
      create(:component)
      create(:component, :with_option_ids)
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

  describe '#show' do
    context 'component without options' do
      it 'renders the correct JSON representation of the component' do
        component = create(:component)
        get(url + component.id.to_s)
    
        component = JSON.parse(response.body)['data']
        products = JSON.parse(response.body)['included']
    
        expect(component.keys).to match_array(%w[id type attributes relationships])
        expect(component['type']).to eq('component')
        expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
        expect(component['relationships'].keys).to match_array(%w[options])
        expect(component['relationships']['options'].keys).to match_array(%w[data])
        
        expect(products).to eq([])
      end
    end

    context 'component with options' do
      it 'renders the correct JSON representation of the component' do
        component = create(:component, :with_option_ids)
        get(url + component.id.to_s)
    
        component = JSON.parse(response.body)['data']    
        expect(component.keys).to match_array(%w[id type attributes relationships])
        expect(component['type']).to eq('component')
        expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
        expect(component['relationships'].keys).to match_array(%w[options])
        expect(component['relationships']['options'].keys).to match_array(%w[data])
        expect(component['relationships']['options']['data']).not_to eq([])

        component['relationships']['options']['data'].each do |data|
          expect(data.keys).to match_array(%w[id type])
          expect(data['type']).to eq('product')
        end
        
        products = JSON.parse(response.body)['included']
        expect(products).not_to eq([])
    
        products.each do |product|
          expect(product.keys).to match_array(%w[id type attributes relationships])
          expect(product['type']).to eq('product')
          expect(product['attributes'].keys).to match_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount slug isVisible unitOfMeasure])
          expect(product['attributes']['type']).to eq('Simple')
          
          product['relationships']['categories']['data'].each do |data|
            expect(data.keys).to match_array(%w[id type])
            expect(data['type']).to eq('category')
          end
        end
      end
    end

    context 'component id is used as identifying param' do
      let!(:component) { create(:component) }
      let!(:id) { component.id.to_s }
  
      it 'returns http status 200 OK' do
        get(url + id)
        expect(response).to have_http_status(200)
      end
  
      it 'returns expected component' do
        get(url + id)
        body = JSON.parse(response.body)
        expect(body['data']['type']).to eq('component')
        expect(body['data']['id']).to eq(id)
      end

      context "when component doesn't exist" do
        let!(:bad_id) { (id.to_i + 1).to_s }

        it 'returns a 404 status code' do
          get(url + bad_id)
          expect(response).to have_http_status(404)
        end

        it 'returns an error' do
          get(url + bad_id)
          body = JSON.parse(response.body)
          expect(body['error']).to eq("The requested component doesn't exist")
        end
      end
    end

    context 'component slug is used as identifying param' do
      let!(:component) { create(:component) }
      let!(:slug) { component.slug }
  
      before { get(url + slug) }
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(200)
      end
  
      it 'returns expected component' do
        body = JSON.parse(response.body)
        expect(body['data']['type']).to eq('component')
        expect(body['data']['attributes']['slug']).to eq(slug)
      end

      context "when component doesn't exist" do
        let!(:bad_slug) { slug + slug }

        it 'returns a 404 status code' do
          get(url + bad_slug)
          expect(response).to have_http_status(404)
        end

        it 'returns an error' do
          get(url + bad_slug)
          body = JSON.parse(response.body)
          expect(body['error']).to eq("The requested component doesn't exist")
        end
      end
    end
  end

  describe '#create' do
    context 'valid request with only required attributes' do
      before do
        post(url, params: { component: attributes_for(:component) })
      end
  
      it 'returns 200' do
        expect(response).to have_http_status(:success)
      end
  
      it 'renders the correct JSON representation of the new component' do  
        component = JSON.parse(response.body)['data']
        products = JSON.parse(response.body)['included']
  
        expect(component.keys).to match_array(%w[id type attributes relationships])
        expect(component['type']).to eq('component')
        expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
        expect(component['relationships'].keys).to match_array(%w[options])
        expect(component['relationships']['options'].keys).to match_array(%w[data])

        expect(products).to eq([])
      end
      
      it 'sets image to nil' do
        expect(JSON.parse(response.body)['data']['attributes']['image']).to be(nil)
      end

      it 'sets min_quantity to 1' do
        expect(JSON.parse(response.body)['data']['attributes']['minQuantity']).to be(1)
      end

      it 'sets max_quantity to nil' do
        expect(JSON.parse(response.body)['data']['attributes']['maxQuantity']).to be(nil)
      end

      it 'sets is_enabled to true' do
        expect(JSON.parse(response.body)['data']['attributes']['isEnabled']).to be(true)
      end
    end

    context 'valid request with optional attributes' do
      it 'sets image to given value' do
        component_attributes = attributes_for(:component, :with_image)
        post(url, params: { component: component_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['image']).not_to be(nil)
      end

      it 'sets min_quantity to given value' do
        component_attributes = attributes_for(:component, :with_non_default_min_quantity)
        post(url, params: { component: component_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['minQuantity']).to be(2)
      end

      it 'sets max_quantity to given value' do
        component_attributes = attributes_for(:component, :with_max_quantity)
        post(url, params: { component: component_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['maxQuantity']).to be(2)
      end

      it 'sets is_enabled to given false' do
        component_attributes = attributes_for(:component, :is_not_enabled)
        post(url, params: { component: component_attributes })
        expect(JSON.parse(response.body)['data']['attributes']['isEnabled']).to be(false)
      end
    end

    context 'valid request with only required attributes and component options' do
      it 'renders the correct JSON representation of the new component' do
        post(url, params: { component: attributes_for(:component, :with_option_ids)})
    
        component = JSON.parse(response.body)['data']    
        expect(component.keys).to match_array(%w[id type attributes relationships])
        expect(component['type']).to eq('component')
        expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
        expect(component['relationships'].keys).to match_array(%w[options])
        expect(component['relationships']['options'].keys).to match_array(%w[data])
        expect(component['relationships']['options']['data']).not_to eq([])

        component['relationships']['options']['data'].each do |data|
          expect(data.keys).to match_array(%w[id type])
          expect(data['type']).to eq('product')
        end
        
        products = JSON.parse(response.body)['included']
        expect(products).not_to eq([])
    
        products.each do |product|
          expect(product.keys).to match_array(%w[id type attributes relationships])
          expect(product['type']).to eq('product')
          expect(product['attributes'].keys).to match_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount slug isVisible unitOfMeasure])
          expect(product['attributes']['type']).to eq('Simple')
          
          product['relationships']['categories']['data'].each do |data|
            expect(data.keys).to match_array(%w[id type])
            expect(data['type']).to eq('category')
          end
        end
      end
    end

    context 'invalid request' do
      context 'name attribute is missing' do
        before do
          post(url, params: { component: attributes_for(:component, :no_name) })  
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
          post(url, params: { component: attributes_for(:component, :no_description) })
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
    end
  end

  describe '#update' do
    context 'name update' do
      let!(:original_name) { Faker::Lorem.words(number: 2).map(&:capitalize).join(' ') }
      let!(:new_name) { 'Updated Name' }
  
      before do
        post(url, params: { component: attributes_for(:component, name: original_name) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { name: new_name } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the name' do
        patch(url + @id, params: { component: { name: new_name } })
        current_name = JSON.parse(response.body)['data']['attributes']['name']
        expect(current_name).not_to eq(original_name)
        expect(current_name).to eq(new_name)
      end
  
      it 'updates the slug when the name is updated' do
        original_slug = JSON.parse(response.body)['data']['attributes']['slug']
        new_slug = new_name.split(' ').map(&:downcase).join('-')
        patch(url + @id, params: { component: { name: new_name } })
        current_slug = JSON.parse(response.body)['data']['attributes']['slug']
        expect(current_slug).not_to eq(original_slug)
        expect(current_slug).to eq(new_slug)
      end
    end
  
    context 'description update' do
      let!(:original_description) { Faker::Lorem.paragraph }
      let!(:new_description) { Faker::Lorem.paragraph }
  
      before do
        post(url, params: { component: attributes_for(:component, description: original_description) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { description: new_description } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        patch(url + @id, params: { component: { description: new_description } })
        current_description = JSON.parse(response.body)['data']['attributes']['description']
        expect(current_description).not_to eq(original_description)
        expect(current_description).to eq(new_description)
      end
    end
  
    context 'image update' do
      let!(:new_image) { Faker::Internet.url(host: 'example.com') }
  
      before do
        post(url, params: { component: attributes_for(:component, :with_image) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { image: new_image } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        original_image = JSON.parse(response.body)['data']['attributes']['image']
        patch(url + @id, params: { component: { image: new_image } })
        current_image = JSON.parse(response.body)['data']['attributes']['image']
        expect(current_image).not_to eq(original_image)
        expect(current_image).to eq(new_image)
      end
    end

    context 'min_quantity update' do
      let!(:new_min_quantity) { 2 }
  
      before do
        post(url, params: { component: attributes_for(:component, :with_image) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { min_quantity: new_min_quantity } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the min_quantity' do
        original_min_quantity = JSON.parse(response.body)['data']['attributes']['minQuantity']
        patch(url + @id, params: { component: { min_quantity: new_min_quantity } })
        current_min_quantity = JSON.parse(response.body)['data']['attributes']['minQuantity']
        expect(current_min_quantity).not_to eq(original_min_quantity)
        expect(current_min_quantity).to eq(new_min_quantity)
      end
    end

    context 'max_quantity update' do
      let!(:new_max_quantity) { 3 }
  
      before do
        post(url, params: { component: attributes_for(:component, :with_max_quantity) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { max_quantity: new_max_quantity } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the max_quantity' do
        original_max_quantity = JSON.parse(response.body)['data']['attributes']['maxQuantity']
        patch(url + @id, params: { component: { max_quantity: new_max_quantity } })
        current_max_quantity = JSON.parse(response.body)['data']['attributes']['maxQuantity']
        expect(current_max_quantity).not_to eq(original_max_quantity)
        expect(current_max_quantity).to eq(new_max_quantity)
      end
    end

    context 'is_enabled update' do
      let!(:new_is_enabled) { false }
  
      before do
        post(url, params: { component: attributes_for(:component) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { is_enabled: new_is_enabled } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the max_quantity' do
        original_is_enabled = JSON.parse(response.body)['data']['attributes']['isEnabled']
        patch(url + @id, params: { component: { is_enabled: new_is_enabled } })
        current_is_enabled = JSON.parse(response.body)['data']['attributes']['isEnabled']
        expect(current_is_enabled).not_to eq(original_is_enabled)
        expect(current_is_enabled).to eq(new_is_enabled)
      end
    end

    context 'product_option_ids update' do
      before do
        component_attributes = attributes_for(:component, :with_option_ids)
        post(url, params: { component: component_attributes })
        body = JSON.parse(response.body)
        @id = body['data']['id'].to_s
        @options_product_id_1 = body['data']['relationships']['options']['data'][0]['id']
      end

      it 'adds a relationship with a simple product as a component option' do
        original_options_products = JSON.parse(response.body)['data']['relationships']['options']['data']
        options_product_id_2 = original_options_products[1]['id']
        options_product_id_3 = create(:simple_product_with_category_ids)['id'].to_s
        expect(original_options_products.count).to eq(2)
        patch(url + @id, params: { component: { option_ids: [@options_product_id_1, options_product_id_2, options_product_id_3] } })
        current_options_products = JSON.parse(response.body)['data']['relationships']['options']['data']
        expect(current_options_products.count).to eq(3)
        expect(current_options_products[0]['id']).to eq(@options_product_id_1)
        expect(current_options_products[1]['id']).to eq(options_product_id_2)
        expect(current_options_products[2]['id']).to eq(options_product_id_3)
      end

      it 'removes a relationship with a simple product as a component option' do
        expect(JSON.parse(response.body)['data']['relationships']['options']['data'].count).to eq(2)
        patch(url + @id, params: { component: { option_ids: [@options_product_id_1] } })
        options_products = JSON.parse(response.body)['data']['relationships']['options']['data']
        expect(options_products.count).to eq(1)
        expect(options_products[0]['id']).to eq(@options_product_id_1)
      end
    end
  end

  describe '#destroy' do
    before do
      post(url, params: { component: attributes_for(:component) })
    end
  
    context 'when component id is used as identifying param' do
      let!(:id) { JSON.parse(response.body)['data']['id'] }
  
      it 'deletes the component' do
        expect do
          delete(url + id)
        end.to change(Component, :count).by(-1)
      end
  
      it 'returns a 204 status code' do
        delete(url + id)
        expect(response).to have_http_status(204)
      end
  
      it 'returns an empty body' do
        delete(url + id)
        expect(response.body).to eq('')
      end

      it 'returns an error when component does not exist' do
        delete(url + (id.to_i + 1).to_s)
        body = JSON.parse(response.body)
        expect(body['error']).to eq("The requested component doesn't exist")
      end

      it 'returns a 404 status code when component does not exist' do
        delete(url + (id.to_i + 1).to_s)
        expect(response).to have_http_status(404)
      end
    end
  
    context 'using component slug is used as identifying param' do
      let!(:slug) { JSON.parse(response.body)['data']['attributes']['slug'] }
  
      it 'deletes the component' do        
        expect do
          delete(url + slug)
        end.to change(Component, :count).by(-1)
      end
  
      it 'returns a 204 status code' do
        delete(url + slug)
        expect(response).to have_http_status(204)
      end
  
      it 'returns an empty body' do
        delete(url + slug)
        expect(response.body).to eq('')
      end

      it 'returns an error when component does not exist' do
        delete(url + slug + slug)
        body = JSON.parse(response.body)
        expect(body['error']).to eq("The requested component doesn't exist")
      end

      it 'returns a 404 status code when component does not exist' do
        delete(url + slug + slug)
        expect(response).to have_http_status(404)
      end
    end
  end
end
