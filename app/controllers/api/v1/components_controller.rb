module Api
  module V1
    class ComponentsController < ApplicationController
      before_action :set_component, only: [:show, :update, :destroy]

      def index
        components = Component.all
        render json: ComponentSerializer.new(components).serializable_hash.to_json
      end

      def show
        render_component_as_json(@component)
      end

      def create
        component = Component.new(component_params)

        if component.save
          render_component_as_json(component)
        else
          render_errors_as_json(component)
        end
      end

      def update
        if @component.update(component_params)
          render_component_as_json(@component)
        else
          render_errors_as_json(@component)
        end
      end

      def destroy
        if @component.destroy
          head :no_content
        else
          render_errors_as_json(@component)
        end
      end

      private

      def set_component
        @component = Component.friendly.find(params[:id])
      end

      def component_params
        params.require(:component)
          .permit(:name,
                  :description,
                  :image,
                  :min_quantity,
                  :max_quantity,
                  :is_enabled,
                  product_option_ids: []
          )
      end

      def render_component_as_json(component)
        render json: ComponentSerializer.new(component, include: [:options]).serializable_hash.to_json
      end

      def render_errors_as_json(component)
        render json: { errors: component.errors.messages }, status: 422
      end
    end
  end
end