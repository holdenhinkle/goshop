module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show]

      def show
        if @user
          render_user_as_json(@user)
        else
          render_404_as_json
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        @user = nil
      end

      def render_404_as_json
        payload = {
          error: "The requested user doesn't exist",
          status: 404
        }

        render json: payload, status: 404   
      end
    end
  end
end