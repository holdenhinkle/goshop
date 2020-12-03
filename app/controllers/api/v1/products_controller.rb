module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = Product.all
        render json: ProductSerializer.new(products).serializable_hash.to_json
      end
    end
  end
end