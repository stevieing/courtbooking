class AdminClosureForm

  include FormManager
  include OverlappingRecordsManager

  set_model :closure, PERMITTED_ATTRIBUTES.closure.whitelist
  overlapping_object :model
  before_save :remove_overlapping

  validate :verify_closure
  validate :verify_overlapping_records_removal

  def process_parameters(params)
    process_allow_removal(params)
  end

end