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

  def process_allow_removal(params)
    self.allow_removal = to_boolean(params[:allow_removal])
    params.slice!(:allow_removal)
  end

private

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end