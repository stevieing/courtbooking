class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!, :authorise
  after_filter :store_location

  delegate :allow?, :allow_param?, to: :current_permission

  def current_year
    @current_year ||= Date.today.year
  end

  def header
    @header ||= "#{params[:action].capitalize} #{params[:controller].split('/').last.capitalize.singularize}"
  end

  helper_method :allow?, :allow_param?, :current_year, :header

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

  ##
  # TODO: all of the following methods manage redirections after sign in and various situations.
  # this is probably better managed in routes. Need to find a way to do that.
  #

  def store_location
    session[:return_to] = request.referer if request.get?
  end

  def get_location(default)
    session.delete(:return_to) || default
  end

  def redirect_back_or_default(default)
    redirect_to(get_location(default))
  end

  def js_redirect_back_or_default(default)
    render js: %(window.location.href='#{get_location(default)}')
  end

  def after_sign_in_path_for(resource)
    session[:return_to] || root_path
  end

end