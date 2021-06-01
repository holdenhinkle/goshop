class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_tenant_by_tenant_id

  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def set_tenant_by_tenant_id
    current_account = Account.find_by(tenant_id: params[:tenant_id])
    set_current_tenant(current_account)
  end

  def not_found
    render json: {
      'errors': [
        {
          'status': '404',
          'title': 'Not Found'
        }
      ]
    }, status: 404
  end

  def record_invalid(message)
    render json: {
      'errors': [
        {
          'status': '400',
          'title': message
        }
      ]
    }, status: 400
  end
end
