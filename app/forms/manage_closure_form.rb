class ManageClosureForm

	include ManageForm
  set_model :closure, ACCEPTED_ATTRIBUTES.closure
  set_associated_models :courts
	
	validate :verify_closure
	
end