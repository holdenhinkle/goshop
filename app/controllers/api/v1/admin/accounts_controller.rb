require 'pry'

module Api
  module V1
    module Admin
      class AccountsController < ApplicationController
        before_action :set_account, only: [:update, :show, :destroy]

        def index
          accounts = Account.all

          render json: AccountSerializer.new(accounts).serializable_hash.to_json
        end

        def show
          if @account
            render_account_as_json(@account)
          else
            render_404_as_json
          end
        end

        def create
          tenant_id = AvailableTenantId.first.destroy.tenant_id
          account = Account.new(account_params)
          account.tenant_id = tenant_id

          if account.save
            render_account_as_json(account)
          else
            render_errors_as_json(account)
          end
        end

        def update
          if @account&.update(account_params)
            render_account_as_json(@account)
          elsif @account
            render_errors_as_json(@account)
          else
            render_404_as_json
          end
        end

        def destroy
          if @account&.destroy
            head :no_content
          else
            render_404_as_json
          end
        end

        private

        def set_account
          raise ActiveRecord::RecordNotFound if is_uuid?
          @account = Account.find_by(tenant_id: params[:id])
        rescue ActiveRecord::RecordNotFound => e
          @account = nil
        end

        def account_params
          params.require(:account).permit(:name)
        end

        def render_account_as_json(account)
          render json: AccountSerializer.new(account).serializable_hash.to_json
        end

        def render_errors_as_json(account)
          render json: { errors: account.errors.messages }, status: 422
        end

        def render_404_as_json
          payload = {
            error: "The requested account doesn't exist",
            status: 404
          }

          render json: payload, status: 404   
        end
      end
    end
  end
end