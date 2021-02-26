require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :request do
  let!(:url) { 'http://localhost:3000/api/v1/categories/' }

  describe "#index" do
    before do
      2.times { create(:category) }
      get(url)
    end

    it "returns http status 200 OK" do
      expect(response).to have_http_status(:success)
    end

    it "returns two category objects" do
      categories = JSON.parse(response.body)['data']
      expect(categories.count).to eq(2)
    end

    it 'renders the correct JSON representation of the existing categories' do
      json_response = JSON.parse(response.body)

      json_response['data'].each do |category|
        expect(category.keys).to match_array(%w[id type attributes])
        expect(category['type']).to eq('category')
        expect(category['attributes'].keys).to match_array(%w[name description image slug])
      end
    end
  end

  describe '#show' do
    let!(:category) { create(:category) }

    context 'valid request' do
      let!(:id) { category.id.to_s }
      let!(:slug) { category.slug }

      it 'returns http status 200 OK' do
        get(url + id)
        expect(response).to have_http_status(200)
      end

      it 'returns expected category when category id is used' do
        get(url + id)
        body = JSON.parse(response.body)
        expect(body['data']['type']).to eq('category')
        expect(body['data']['id']).to eq(id)
      end

      it 'returns expected category when category slug is used' do
        get(url + slug)
        body = JSON.parse(response.body)
        expect(body['data']['type']).to eq('category')
        expect(body['data']['id']).to eq(id)
        expect(body['data']['attributes']['slug']).to eq(slug)
      end

      it 'renders the correct JSON representation of the category' do
        get(url + id)
        body = JSON.parse(response.body)
        expect(body['data'].keys).to match_array(%w[id type attributes])
        expect(body['data']['type']).to eq('category')
        expect(body['data']['attributes'].keys).to match_array(%w[name description image slug])
      end
    end

    context 'invalid request' do
      it 'returns http status code 404 when category does not exist' do
        get(url + (category.id + 1).to_s)
        expect(response).to have_http_status(404)
      end

      it 'returns correct error message when category does not exist' do
        get(url + (category.id + 1).to_s)
        body = JSON.parse(response.body)
        expect(body['error']).to eq("The requested category does't exist")
      end
    end
  end

  describe '#create' do
    context 'valid request' do
      let!(:name) { Faker::Lorem.words(number: 2).map(&:capitalize).join(' ') }

      before do
        category = attributes_for(:category, name: name)
        post(url, params: { category: category })
      end

      it 'renders the correct JSON representation of the new category' do
        body = JSON.parse(response.body)
        expect(body['data'].keys).to match_array(%w[id type attributes])
        expect(body['data']['type']).to eq('category')
        expect(body['data']['attributes'].keys).to match_array(%w[name description image slug])
      end

      it 'returns http status 200 OK when both name and description are given' do
        expect(response).to have_http_status(:success)
      end

      it 'sluggifies the category name' do
        body = JSON.parse(response.body)
        slug = name.split(' ').map(&:downcase).join('-')
        expect(body['data']['attributes']['slug']).to eq(slug)
      end
    end

    context 'invalid request' do
      it 'returns the correct error message when an existing name is given' do
        name = Faker::Lorem.words(number: 2).map(&:capitalize).join(' ')

        2.times do
          category = attributes_for(:category, name: name)
          post(url, params: { category: category })
        end

        body = JSON.parse(response.body)
        expect(body['errors'].count).to eq(1)
        expect(body['errors']['name'].count).to eq(1)
        expect(body['errors']['name'][0]).to eq('has already been taken')
      end

      context 'name is missing' do
        before do
          category = attributes_for(:category, :no_name)
          post(url, params: { category: category })
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(422)   
        end

        it 'returns the correct error message' do
          body = JSON.parse(response.body)
          expect(body['errors'].count).to eq(1)
          expect(body['errors']['name'].count).to eq(1)
          expect(body['errors']['name'][0]).to eq("can't be blank")
        end
      end

      context 'description is missing' do
        before do
          category = attributes_for(:category, :no_description)
          post(url, params: { category: category })
        end

        it 'returns http status 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns the correct error message' do
          body = JSON.parse(response.body)
          expect(body['errors'].count).to eq(1)
          expect(body['errors']['description'].count).to eq(1)
          expect(body['errors']['description'][0]).to eq("can't be blank")
        end
      end
    end
  end

  describe '#update' do
    context 'valid request' do
      before do
        category = attributes_for(:category, :with_image)
        post(url, params: { category: category })
        @id = JSON.parse(response.body)['data']['id']
      end

      it 'returns a 200 success response' do
        patch(url + @id, params: { category: { name: 'Updated Name' } })
        expect(response).to have_http_status(:success)
      end

      it 'updates the name' do
        original_name = JSON.parse(response.body)['data']['attributes']['name']
        updated_name = 'Updated Name'
        patch(url + @id, params: { category: { name: 'Updated Name' } })
        current_name = JSON.parse(response.body)['data']['attributes']['name']
        expect(current_name).to eq(updated_name)
        expect(current_name).not_to eq(original_name)
      end

      it 'updates the slug when the name is updated' do
        original_slug = JSON.parse(response.body)['data']['attributes']['slug']
        updated_name = 'Updated Name'
        updated_slug = updated_name.split(' ').map(&:downcase).join('-')
        patch(url + @id, params: { category: { name: updated_name } })
        current_slug = JSON.parse(response.body)['data']['attributes']['slug']
        expect(current_slug).not_to eq(original_slug)
        expect(current_slug).to eq(updated_slug)
      end

      it 'updates the description' do
        original_description = JSON.parse(response.body)['data']['attributes']['description']
        updated_description = 'Updated description.'
        patch(url + @id, params: { category: { description: 'Updated description.' } })
        current_description = JSON.parse(response.body)['data']['attributes']['description']
        expect(current_description).to eq(updated_description)
        expect(current_description).not_to eq(original_description)       
      end

      it 'updates the image' do
        original_image = JSON.parse(response.body)['data']['attributes']['image']
        updated_image = Faker::Internet.url(host: 'example.com')
        patch(url + @id, params: { category: { image: updated_image } })
        current_image = JSON.parse(response.body)['data']['attributes']['image']
        expect(current_image).to eq(updated_image)
        expect(current_image).not_to eq(original_image)   
      end

      it 'renders the correct JSON representation of the updated category' do
        updated_category = {
          name: 'Updated Name',
          description: 'Updated description.',
          image: Faker::Internet.url(host: 'example.com')
        }

        patch(url + @id, params: { category: updated_category })
        body = JSON.parse(response.body)
        expect(body['data'].keys).to match_array(%w[id type attributes])
        expect(body['data']['type']).to eq('category')
        expect(body['data']['attributes'].keys).to match_array(%w[name description image slug])       
      end
    end

    context 'invalid request' do
      before do
        2.times do |n|
          category = attributes_for(:category, name: "Category #{n}")
          post(url, params: { category: category })
        end

        @id = JSON.parse(response.body)['data']['id']

        # Try to make the categories have the same name (names must be unique)
        patch(url + @id, params: { category: { name: 'Category 0' } })
      end

      it 'returns a 422 Unprocessable Entity status code' do
        expect(response).to have_http_status(422)
      end

      it 'returns the correct error message when an existing name is given' do
        body = JSON.parse(response.body)
        expect(body['errors']['name'].first).to eq('has already been taken')
      end
    end

    context 'category does not exist' do
      before do
        category = attributes_for(:category)
        patch(url + '1', params: { category: category })
      end

      it 'returns a 404 status code' do
        expect(response).to have_http_status(404)  
      end

      it 'returns the correct error message' do
        body = JSON.parse(response.body)
        expect(body['error']).to eq("The requested category does't exist")
      end
    end
  end

  describe '#destroy' do
    context 'valid request' do
      before do
        category = attributes_for(:category)
        post(url, params: { category: category })
      end

      it 'deletes the category when the category id is used as identifying param' do
        id = JSON.parse(response.body)['data']['id']

        expect do
          delete(url + id)
        end.to change(Category, :count).by(-1)
      end

      it 'deletes the category when the category slug is used as identifying param' do
        slug = JSON.parse(response.body)['data']['attributes']['slug']
        
        expect do
          delete(url + slug)
        end.to change(Category, :count).by(-1)
      end

      it 'returns a 204 status code' do
        id = JSON.parse(response.body)['data']['id']
        delete(url + id)
        expect(response).to have_http_status(204)
      end

      it 'returns an empty body' do
        id = JSON.parse(response.body)['data']['id']
        delete(url + id)
        expect(response.body).to eq('')
      end
    end

    context 'category does not exist' do
      before { delete(url + '1') }

      it 'returns a 404 status code' do
        expect(response).to have_http_status(404)  
      end

      it 'returns the correct error message' do
        body = JSON.parse(response.body)
        expect(body['error']).to eq("The requested category does't exist")
      end
    end
  end
end
