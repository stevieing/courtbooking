class AdminEventForm

  include FormManager

  set_model :event, ACCEPTED_ATTRIBUTES.event
  validate :verify_event

end