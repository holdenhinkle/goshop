module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      def create
        build_resource(sign_up_params)
        resource.save
        sign_up(resource_name, resource) if resource.persisted?
        render_user_as_json(resource)
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password)
      end

      def render_user_as_json(user)
        render json: UserSerializer.new(user).serializable_hash.to_json        
      end
    end
  end
end