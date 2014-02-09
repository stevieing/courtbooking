class ManageClosureForm

	include ManageForm
  set_model :closure, ACCEPTED_ATTRIBUTES.closure
	
	validate :verify_closure
	
end