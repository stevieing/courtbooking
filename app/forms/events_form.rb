class EventsForm
  include BasicForm
  include OverlappingRecordsManager

  set_model :event, PERMITTED_ATTRIBUTES.event.whitelist
  overlapping_object :event

  validate :verify_event
  validate :verify_overlapping_records_removal

  def submit(params)
    self.allow_removal = to_boolean(params[:allow_removal])
    save(params)
  end

private

  def save_objects
    run_transaction do
     remove_overlapping
     event.save
    end
  end

  def verify_event
    check_for_errors event
  end

  def to_boolean(value)
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end
end