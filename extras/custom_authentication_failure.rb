class CustomAuthenticationFailure < Devise::FailureApp
  protected

  def redirect_url
    sign_in_path
  end

end
