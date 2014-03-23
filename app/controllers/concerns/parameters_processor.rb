module ParametersProcessor

  def process_password(params)
    params.tap do |p|
      if p[:password].blank? && p[:password_confirmation].blank?
        p.delete_all(:password, :password_confirmation)
      end
    end
  end

  def permit_parameters(params, attributes)
    params.permit(*attributes)
  end
end