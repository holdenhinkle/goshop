require 'pry'

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        products = Product.all

        render json: ProductSerializer.new(products).serializable_hash.to_json
      end

      def show
        render json: ProductSerializer.new(@product).serializable_hash.to_json
      end

      def create
        product = Product.new(product_params)

        if product.save
          render json: ProductSerializer.new(product).serializable_hash.to_json
        else
          render json: { error: product.errors.messages }, status: 422
        end
      end

      def update
        if @product.update(product_params)
          render json: ProductSerializer.new(@product).serializable_hash.to_json
        else
          render json: { error: @product.errors.messages }, status: 422
        end
      end

      def destroy
        if @product.destroy
          head :no_content
        else
          render json: { errors: @product.errors }, status: 422
        end
      end

      private

      def set_product
        @product = Product.friendly.find(params[:id])
      end

      def product_params
        params
          .require(:product)
            .permit(:name,
                    :description,
                    :image,
                    :product_type,
                    :regular_price,
                    :sale_price,
                    :inventory_amount,
                    :inventory_unit_type,
                    :is_visable,
                    category_ids: []
            )
      end
    end
  end
end