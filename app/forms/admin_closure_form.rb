class AdminClosureForm

  include FormManager

  set_model :closure, ACCEPTED_ATTRIBUTES.closure

  validate :verify_closure

end