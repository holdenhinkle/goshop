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

      def create
        product = Product.new(product_params)

        if product.save
          render json: ProductSerializer.new(product).serializable_hash.to_json
        else
          render json: { error: product.errors.messages }, status: 422
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :description, :image, :product_type, :regular_price, :sale_price, :inventory_amount, :inventory_unit_type, :is_visable)
      end
    end
  end
end