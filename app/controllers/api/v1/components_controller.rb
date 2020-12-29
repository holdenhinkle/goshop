module Api
  module V1
    class ComponentsController < ApplicationController
      before_action :set_component, only: [:show, :update, :destroy]

      def index
        components = Component.all
        render json: ComponentSerializer.new(components).serializable_hash.to_json
      end

      def show
        render json: ComponentSerializer.new(@component).serializable_hash.to_json
      end

      def create
        component = Component.new(component_params)

        if component.save!
          render json: ComponentSerializer.new(component).serializable_hash.to_json
        else
          render json: { errors: component.errors.messages }, status: 422
        end
      end

      def update
        if @component.update(component_params)
          render json: ComponentSerializer.new(@component).serializable_hash.to_json
        else
          render json: { errors: @component.errors.messages }, status: 422
        end
      end

      def destroy
        if @component.destroy
          head :no_content
        else
          render json: { errors: @component.errors.messages }, status: 442
        end
      end

      private

      def set_component
        @component = Component.friendly.find(params[:id])
      end

      def component_params
        params.require(:component).permit(:name,
                                          :description,
                                          :image,
                                          :min_quantity,
                                          :max_quantity,
                                          :is_enabled)
      end
    end
  end
end