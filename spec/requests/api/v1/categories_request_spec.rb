require 'rails_helper'
require 'pry'

RSpec.describe Api::V1::CategoriesController, type: :request do
  url = 'http://localhost:3000/api/v1/categories/'

  describe "GET #index" do
    before do
      Category.create(name: 'category 1', description: 'category 1 description')
      Category.create(name: 'category 2', description: 'category 2 description')
      get(url)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns two category objects" do
      categories = JSON.parse(response.body)['data']
      categories.size.should eq(2)
    end
  end
end
