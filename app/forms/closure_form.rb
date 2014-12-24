class ClosureForm
  include BasicForm
  include OverlappingRecordsManager

  set_model Closure, PERMITTED_ATTRIBUTES.closure.whitelist
  overlapping_object :closure

  validate :verify_closure
  validate :verify_overlapping_records_removal

  def submit(params)
    self.allow_removal = to_boolean(params[:allow_removal])
    push_and_save(params)
  end

  def save_objects
    run_transaction do
      remove_overlapping
      closure.save
    end
  end

private

  def verify_closure
    check_for_errors closure
  end

end