module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]

      def index
        products = Product.all
        render json: ProductSerializer.new(products).serializable_hash.to_json
      end

      def show
        if @product
          render_product_as_json(@product)
        else
          render_404_as_json
        end
      end

      def create
        update_decimal_prices
        product = Product.new(product_params)
        slugs = params[:product][:category_slugs]
        product.category_slugs(slugs) if slugs.present?

        if product.save
          render_product_as_json(product)
        else
          render_errors_as_json(product)
        end
      end

      def update
        update_decimal_prices

        if @product&.update(product_params)
          render_product_as_json(@product)
        elsif @product
          render_errors_as_json(@product)
        else
          render_404_as_json
        end
      end

      def destroy
        if @product&.destroy
          head :no_content
        else
          render_404_as_json
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
        params[:product][:regular_price_cents]
      end

      def sale_price
        params[:product][:sale_price_cents]
      end

      def set_product
        raise ActiveRecord::RecordNotFound if is_uuid?
        @product = Product.friendly.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        @product = nil
      end

      def product_params
        params
          .require(:product)
            .permit(:name,
                    :description,
                    :image,
                    :type,
                    :regular_price_cents,
                    :sale_price_cents,
                    :inventory_amount,
                    :unit_of_measure,
                    :is_visible,
                    category_slugs: [],
                    # category_ids: [],
                    component_ids: [],
                    categories_attributes: [:id,
                                            :name,
                                            :description],
                    components_attributes: [:id,
                                            :name,
                                            :description,
                                            :image,
                                            :slug,
                                            :min_quantity,
                                            :max_quantity,
                                            :is_enabled,
                                            product_option_ids: []
                                           ]
            )
      end

      def render_product_as_json(product)
        case product.type
        when 'Composite'
          render json: CompositeSerializer.new(product, include: [:categories, "components.options"]).serializable_hash.to_json
        when 'Simple'
          render json: SimpleSerializer.new(product, include: [:categories]).serializable_hash.to_json
        end        
      end

      def render_errors_as_json(product)
        render json: { errors: product.errors }, status: 422
      end

      def render_404_as_json
        payload = {
          error: "The requested product doesn't exist",
          status: 404
        }

        render json: payload, status: 404   
      end
    end
  end
end
