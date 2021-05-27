class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :set_tenant_by_tenant_id

  private

  def set_tenant_by_tenant_id
    current_account = Account.find_by(tenant_id: params[:tenant_id])
    set_current_tenant(current_account)
  end

  def is_uuid?
    regex = /^[0-9A-F]{8}-[0-9A-F]{4}-[4][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i

    if params[:id]
      params[:id].match(regex)
    elsif params[:slug]
      params[:slug].match(regex)
    elsif params[:tenant_id]
      params[:tenant_id].match(regex)
    end

    false
  end
end
