module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = Product.all
        render json: ProductSerializer.new(products).serializable_hash.to_json
      end

      def show
        product = Product.find(params[:id])
        render json: ProductSerializer.new(product).serializable_hash.to_json
      end
    end
  end
end