class AdminClosureForm

  include FormManager
  include OverlappingRecordsManager

  #
  # TODO: this is a hack. Virtual attributes that are not delegated to the model
  # need to be dealt with differently.
  #
  set_model :closure, ACCEPTED_ATTRIBUTES.closure - [:allow_removal]
  overlapping_object :model
  after_submit :remove_overlapping

  validate :verify_closure
  validate :verify_overlapping_records_removal

  def process_parameters(params)
    process_allow_removal(params)
  end

end