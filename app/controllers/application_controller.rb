class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!, :authorise
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  delegate :allow_param?, to: :current_permission
  helper_method :allow_param?
  
  def current_year
    @current_year ||= Date.today.year
  end
  helper_method :current_year

  private
  
  def current_permission
    @current_permission ||= Permissions.permission_for(current_user)
  end
  
  def current_resource
    nil
  end
 
  def authorise
    if current_permission.allow?(params[:controller], params[:action], current_resource)
      current_permission.permit_params! params
    else
      redirect_to root_url, alert: "Not authorised."
    end
  end
  
end