module ParametersProcessor

  def process_parameters(params)
    params.tap do |p|
      if p[:password].blank? && p[:password_confirmation].blank?
        p.delete_all(:password, :password_confirmation)
      end
    end
  end
end