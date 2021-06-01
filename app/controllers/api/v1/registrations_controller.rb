module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController

      def new
        # do i need the following?
        # is the check scoped to the tenant_id?
        render(status: :bad_request) && return if User.exists?(email: sign_up_params['email'])

        build_resource(sign_up_params)
        resource.save
        sign_up(resource_name, resource) if resource.persisted?
        render json: resource
      end

      def create
        # do i need the following?
        # is the check scoped to the tenant_id?
        render(status: :bad_request) && return if User.exists?(email: sign_up_params['email'])

        build_resource(sign_up_params)
        resource.save
        sign_up(resource_name, resource) if resource.persisted?
        render json: resource
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password).merge({ account_id: current_tenant.id })
      end

      def render_user_as_json(user)
        render json: UserRegistrationSerializer.new(user).serializable_hash.to_json        
      end
    end
  end
end