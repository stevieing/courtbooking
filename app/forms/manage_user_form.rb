class ManageUserForm

	include ManageForm
	set_model :user, [:username, :email, :password, :password_confirmation, :mail_me]
	set_associated_models :permissions

	def initialize(_user = nil)
		@user = _user unless _user.nil?
	end

	validate :verify_user

	def submit(params)
		set_password_attributes params
		user.attributes = params.slice(*accepted_attributes)
		build_associations params
		if valid?
      save_objects
    else
      false
    end
	end

	private

	def set_password_attributes(params)
		if params[:password].blank? && params[:password_confirmation].blank? && persisted?
			params.delete_all(:password, :password_confirmation)
		end
	end

end