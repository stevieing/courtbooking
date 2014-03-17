##
# TODO: add some RSpec tests.
#
class ManageUserForm

	include ManageForm
  include ParametersProcessor

	set_model :user, ACCEPTED_ATTRIBUTES.user
	delegate :permissions, to: :user

	validate :verify_user

	def process_params(params)
    persisted? ? process_parameters(params) : params
		# params.dup.tap do |p|
		# 	if p[:password].blank? && p[:password_confirmation].blank? && persisted?
		# 		p.delete_all(:password, :password_confirmation)
		# 	end
		# end
	end

  def include_action?(allowed_action)
    permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end

end