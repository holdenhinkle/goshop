class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_tenant_by_tenant_id

  private

  def set_tenant_by_tenant_id
    current_account = Account.find_by(tenant_id: params[:tenant_id])
    set_current_tenant(current_account)
  end
end
