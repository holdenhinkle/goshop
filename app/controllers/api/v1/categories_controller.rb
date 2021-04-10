require 'pry'

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:update, :show, :destroy]

      def index
        category = Category.all

        render json: CategorySerializer.new(category).serializable_hash.to_json
      end

      def show
        if @category
          render_category_as_json(@category)
        else
          render_404_as_json
        end
      end

      def create
        category = Category.new(category_params)

        if category.save
          render_category_as_json(category)
        else
          render_errors_as_json(category)
        end
      end

      def update
        if @category&.update(category_params)
          render_category_as_json(@category)
        elsif @category
          render_errors_as_json(@category)
        else
          render_404_as_json
        end
      end

      def destroy
        if @category&.destroy
          head :no_content
        else
          render_404_as_json
        end
      end

      private

      def set_category
        begin
          @category = Category.friendly.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          @category = nil
        end
      end

      def category_params
        params.require(:category).permit(:name, :description, :image)
      end

      def render_category_as_json(category)
        render json: CategorySerializer.new(category).serializable_hash.to_json
      end

      def render_errors_as_json(category)
        render json: { errors: category.errors.messages }, status: 422
      end

      def render_404_as_json
        payload = {
          error: "The requested category doesn't exist",
          status: 404
        }

        render json: payload, status: 404   
      end
    end
  end
end