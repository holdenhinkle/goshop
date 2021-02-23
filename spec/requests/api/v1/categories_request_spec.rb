require 'rails_helper'
require 'pry'

RSpec.describe Api::V1::CategoriesController, type: :request do
  url = 'http://localhost:3000/api/v1/categories/'

  describe "GET #index" do
    before do
      2.times { create(:category) }
      get(url)
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns two category objects" do
      categories = JSON.parse(response.body)['data']
      expect(categories.count).to eq(2)
    end
  end
end
