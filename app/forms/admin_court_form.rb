class AdminCourtForm
  include FormManager

  set_model :court, PERMITTED_ATTRIBUTES.court.whitelist
  set_associated_models :opening_times, :peak_times

  validate :verify_court
  validate :verify_associated_models

  add_initializer(:number) do
    Court.next_court_number
  end
end