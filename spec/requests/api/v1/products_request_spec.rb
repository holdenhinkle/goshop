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
      include_examples '#show', 'simple', ['categories'] do
        let!(:url) { url }
        let!(:product) { create(:simple_product_with_category_ids) }  
      end
    end

    context 'simple product with category attributes' do
      include_examples '#show', 'simple', ['categories'] do
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

    # add tests for components with no product options
    # add tests for components with product options   
  end

  describe '#create' do
    include_examples '#create', {
      type: 'simple',
      relationships: ['categories'],
      relationships_by: 'category ids',
      factory: :simple_product_with_category_ids
    } do
      let!(:url) { url }
    end

    include_examples '#create', {
      type: 'simple',
      relationships: ['categories'],
      relationships_by: 'category attributes',
      factory: :simple_product_with_categories_attributes
    } do
      let!(:url) { url }
    end

    include_examples '#create', {
      type: 'composite',
      relationships: %w[categories components],
      relationships_by: 'category ids and component ids',
      factory: :composite_product_with_category_ids_and_component_ids
    } do
      let!(:url) { url }
    end

    include_examples '#create', {
      type: 'composite',
      relationships: %w[categories components],
      relationships_by: 'category ids and component attributes',
      factory: :composite_product_with_category_ids_and_component_attributes
    } do
      let!(:url) { url }
    end

    include_examples '#create', {
      type: 'composite',
      relationships: %w[categories components],
      relationships_by: 'category attributes and component ids',
      factory: :composite_product_with_category_attributes_and_component_ids
    } do
      let!(:url) { url }
    end

    include_examples '#create', {
      type: 'composite',
      relationships: %w[categories components],
      relationships_by: 'category attributes and components attributes',
      factory: :composite_product_with_category_attributes_and_component_attributes
    } do
      let!(:url) { url }
    end
  end

  describe '#update' do
    # test updating component
    include_examples '#update', {
      type: 'simple',
      relationships_by: 'category ids',
      factory: :simple_product_with_category_ids
    } do
      let!(:url) { url }
    end

    include_examples '#update', {
      type: 'simple',
      relationships_by: 'category attributes',
      factory: :simple_product_with_categories_attributes
    } do
      let!(:url) { url }
    end

    include_examples '#update', {
      type: 'composite',
      relationships_by: 'category ids and component ids',
      factory: :composite_product_with_category_ids_and_component_ids
    } do
      let!(:url) { url }
    end

    include_examples '#update', {
      type: 'composite',
      relationships_by: 'category ids and component attributes',
      factory: :composite_product_with_category_ids_and_component_attributes
    } do
      let!(:url) { url }
    end

    include_examples '#update', {
      type: 'composite',
      relationships_by: 'category attributes and component ids',
      factory: :composite_product_with_category_attributes_and_component_ids
    } do
      let!(:url) { url }
    end

    include_examples '#update', {
      type: 'composite',
      relationships_by: 'category attributes and components attributes',
      factory: :composite_product_with_category_attributes_and_component_attributes
    } do
      let!(:url) { url }
    end
  end
end

# to-do:
# test pricing => you can enter 999 or 9.99 and regularPriceCents will be 999
# sales_price_currency {} -- delete this one?
# sale_price_currency {} -- or delete this one?
