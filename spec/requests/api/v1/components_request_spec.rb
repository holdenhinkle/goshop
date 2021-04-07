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

  describe '#show' do
    let!(:component) { create(:component) }
  
    it 'renders the correct JSON representation of the component' do
      get(url + component.id.to_s)
  
      component = JSON.parse(response.body)['data']
      products = JSON.parse(response.body)['included']
  
      expect(component.keys).to match_array(%w[id type attributes relationships])
      expect(component['type']).to eq('component')
      expect(component['attributes'].keys).to match_array(%w[name description image slug minQuantity maxQuantity isEnabled])
      expect(component['relationships'].keys).to match_array(%w[options])
      expect(component['relationships']['options'].keys).to match_array(%w[data])
  
      products.each do |product|
        expect(product.keys).to match_array(%w[id type attributes relationships])
        expect(product['type']).to eq('product')
        expect(product['attributes'].keys).to math_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount slug])
        
        product['relationships']['categories']['data'].each do |data|
          expect(data.keys).to match_array(%w[id type])
          expect(data['type']).to eq('category')
        end
      end
    end

    context 'using component id is used as identifying param' do
      let!(:id) { component.id.to_s }
  
      before { get(url + id) }
  
      it 'returns http status 200 OK' do
        expect(response).to have_http_status(200)
      end
  
      it 'returns expected component' do
        body = JSON.parse(response.body)
        expect(body['data']['type']).to eq('component')
        expect(body['data']['id']).to eq(id)
      end
    end

    context 'using component slug is used as identifying param' do
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
    end
  end

  describe '#create' do
    context 'valid request' do
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
  
        products.each do |product|
          expect(product.keys).to match_array(%w[id type attributes relationships])
          expect(product['type']).to eq('product')
          expect(product['attributes'].keys).to math_array(%w[name description image type regularPriceCents salePriceCents inventoryAmount slug])
          
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
      let!(:new_description) { Faker::Lorem.paragraph }
  
      before do
        post(url, params: { component: attributes_for(:component) })
        @id = JSON.parse(response.body)['data']['id'].to_s
      end
  
      it 'returns http status 200 OK' do
        patch(url + @id, params: { component: { description: new_description } })
        expect(response).to have_http_status(:success)
      end
  
      it 'updates the description' do
        original_description = JSON.parse(response.body)['data']['attributes']['description']
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
        expect(body['error']).to eq("The requested component does't exist")
      end

      it 'returns status code 404 when component does not exist' do
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
    end
  end
end