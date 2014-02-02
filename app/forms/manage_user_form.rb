class ManageUserForm

	include ManageForm
	set_model :user, ACCEPTED_ATTRIBUTES.user
	set_associated_models :permissions

	validate :verify_user

	def process_params(params)
		params.dup.tap do |p|
			if p[:password].blank? && p[:password_confirmation].blank? && persisted?
				p.delete_all(:password, :password_confirmation)
			end
		end
	end

end