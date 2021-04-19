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
    # To-do:
    # Test that a composite product with components with product options 
    # returns the correct data.
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
  end

  describe '#create' do
    # To-do:
    # Test that you can create a new composite product with components_attributes
    # that have product_option_ids.
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
    # To-do
    # Test removing product_options from a component.
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

  describe '#destroy' do
    include_examples '#destroy', {
      type: 'simple',
      factory: :simple_product_with_category_ids
    } do
      let!(:url) { url }
    end

    include_examples '#destroy', {
      type: 'composite',
      factory: :composite_product_with_category_ids_and_component_ids
    } do
      let!(:url) { url }
    end
  end
end
