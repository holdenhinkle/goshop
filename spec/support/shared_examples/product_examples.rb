RSpec.shared_examples '#index' do
  it 'returns http status 200 OK' do
    expect(response).to have_http_status(200)
  end

  # it "returns two product objects" do
  #   products = JSON.parse(response.body)['data']
  #   expect(products.count).to eq(2)
  # end

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

RSpec.shared_examples '#show' do
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
