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
        update_decimal_prices

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

      def update_decimal_prices
        params[:product][:regular_price_cents] = (regular_price * 100).to_i if regular_price_decimal?
        params[:product][:sale_price_cents] = (sale_price * 100).to_i if sale_price_decimal?
      end

      def regular_price_decimal?
        decimal? regular_price
      end

      def sale_price_decimal?
        decimal? sale_price
      end

      def decimal?(num)
        num.is_a? Float
      end

      def regular_price
        params[:regular_price_cents]
      end

      def sale_price
        params[:sale_price_cents]
      end

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
                    :regular_price_cents,
                    :sale_price_cents,
                    :inventory_amount,
                    :inventory_unit_type,
                    :is_visable,
                    category_ids: [],
                    categories_attributes: [:id, :name, :description]
            )
      end
    end
  end
end
