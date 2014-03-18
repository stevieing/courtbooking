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
	end

  def include_action?(allowed_action)
    permissions.pluck(:allowed_action_id).include?(allowed_action.id)
  end

end