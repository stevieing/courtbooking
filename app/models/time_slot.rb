class TimeSlot < ActiveRecord::Base
  
  serialize :slots, Array
  
  validates_presence_of :start_time, :finish_time, :slot_time

  validates :start_time, :finish_time, :time => true
  validates_numericality_of :slot_time, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60
  
  before_save :create_slots
  
  private
  
  #TODO need to add some validation to ensure time slots add up
  def create_slots
    write_attribute :slots, self.start_time.hhmm_to_t.to(self.finish_time.hhmm_to_t, self.slot_time.minutes).collect {|t| t.to_s(:hrs_and_mins)}.to_a
  end

end