class ManageCourtForm
  
  include ManageForm
  set_model :court, [:number]
  set_associated_models :opening_times, :peak_times

  def initialize(_court = nil)
    if _court.nil?
      court.number = Court.next_court_number
    else
      @court = _court
    end
  end

  validate :verify_associated_models
  validate :verify_court

  def submit(params)
    court.attributes = params.slice(*accepted_attributes)
    build_associations reject_blank_court_times(params)
    if valid?
      save_objects
    else
      false
    end
  end
  
  private
  
  def reject_blank_court_times(params)
    cleaned_params = {}
    associated_models.each do |association|
      unless params[association.to_s].nil?
        cleaned_params[association.to_s] = params[association.to_s].reject{ |k, court_time| court_time["day"].empty? && court_time["time_from"].empty? && court_time["time_to"].empty?}
      end
    end
    cleaned_params
  end
  
end