class ManageCourtForm
  
  include ManageForm
  set_model :court, ACCEPTED_ATTRIBUTES.court
  set_associated_models :opening_times, :peak_times

  validate :verify_associated_models
  validate :verify_court

  def initialize_attributes
    court.number = Court.next_court_number
  end
  
end