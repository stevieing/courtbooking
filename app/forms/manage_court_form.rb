class ManageCourtForm
  include ActiveModel::Model
  
  def initialize
    court.number = Court.next_court_number
  end
  
  def persisted?
    false
  end
  
  def self.model_name
    ActiveModel::Name.new(self, nil, "Court")
  end
  
  validates_presence_of :number
  validate :verify_unique_court_number
  validate :verify_associated_models
  
  delegate :number, :opening_times, :peak_times, to: :court
  delegate :court_id, :day, :time_from, :time_to, to: :court_time
  
  def court
    @court ||= Court.new
  end
  
  def associated_models
    [:opening_times, :peak_times]
  end

  def submit(params)
    court.attributes = params.slice(:number)
    court.build_opening_times(reject_blank_court_times([params["opening_times"]]))
    court.build_peak_times(reject_blank_court_times([params["peak_times"]]))
    if valid?
      save_objects
    else
      false
    end
  end
  
  private
  
  def save_objects
    begin
      ActiveRecord::Base.transaction do
        court.save!
        court.save_opening_times
        court.save_peak_times
      end
      true
    rescue
      false
    end
  end
  
  def reject_blank_court_times(court_times)
    court_times.reject{ |court_time| court_time["day"].empty? && court_time["time_from"].empty? && court_time["time_to"].empty?}
  end
  
  def verify_unique_court_number
    if Court.exists? number: number
      errors.add :number, "has already been taken"
    end
  end
  
  def verify_associated_models
    associated_models.each do |association|
      court.send(association).each do |object|
        unless object.valid?
          object.errors.each do |key, value|
            errors.add key, value
          end
        end
      end
    end
  end
  
end