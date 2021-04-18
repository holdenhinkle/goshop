require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  url = 'http://localhost:3000/api/v1/products/'

  describe '#index' do
    context 'simple product with category ids' do
      before do
        2.times { create(:simple_product_with_category_ids) }
        get(url)
      end

      include_examples '#index'
    end

    context 'simple product with category attributes' do
      before do
        2.times { create(:simple_product_with_categories_attributes) }
        get(url)
      end

      include_examples '#index'
    end

    context 'composite product with component ids' do
      before do
        2.times { create(:composite_product_with_component_ids) }
        get(url)
      end

      include_examples '#index'
    end

    context 'composite product with components attributes' do
      before do
        2.times { create(:composite_product_with_components_attributes) }
        get(url)
      end

      include_examples '#index'
    end
  end

  describe '#show' do
    context 'simple product with category ids' do
      include_examples '#show', 'simple', %w[categories] do
        let!(:url) { url }
        let!(:product) { create(:simple_product_with_category_ids) }  
      end
    end

    context 'simple product with category attributes' do
      include_examples '#show', 'simple', %w[categories] do
        let!(:url) { url }
        let!(:product) { create(:simple_product_with_categories_attributes) }  
      end
    end

    context 'composite product with component ids' do
      include_examples '#show', 'composite', %w[categories components] do
        let!(:url) { url }
        let!(:product) { create(:composite_product_with_component_ids) }  
      end
    end

    context 'composite product with components attributes' do
      include_examples '#show', 'composite', %w[categories components] do
        let!(:url) { url }
        let!(:product) { create(:composite_product_with_components_attributes) }  
      end
    end
  end

  # # to-do:
  # # test pricing => you can enter 999 or 9.99 and regularPriceCents will be 999
  # # sales_price_currency {} -- delete this one?
  # # sale_price_currency {} -- or delete this one?
end
