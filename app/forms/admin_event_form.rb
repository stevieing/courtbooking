class AdminEventForm

  include FormManager
  include OverlappingRecordsManager

  set_model :event, PERMITTED_ATTRIBUTES.event.whitelist
  overlapping_object :model

  before_save :remove_overlapping

  validate :verify_event
  validate :verify_overlapping_records_removal

  def process_parameters(params)
    process_allow_removal(params)
  end

end