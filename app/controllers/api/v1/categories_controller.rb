module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: [:show, :update, :destroy]

      def index
        category = Category.all

        render json: CategorySerializer.new(category).serializable_hash.to_json
      end

      def show
        render json: CategorySerializer.new(@category).serializable_hash.to_json
      end

      def create
        category = Category.new(category_params)

        if category.save
          render json: CategorySerializer.new(category).serializable_hash.to_json
        else
          render json: { errors: category.errors.messages }, status: 422
        end
      end

      def update
        if @category.update(category_params)
          render json: CategorySerializer.new(@category).serializable_hash.to_json
        else
          render json: { errors: @category.errors.messages }, status: 422
        end
      end

      def destroy
        if @category.destroy
          head :no_content
        else
          render json: { errors: @category.errors.messages }, status: 422
        end
      end

      private

      def set_category
        @category = Category.friendly.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :image)
      end
    end
  end
end