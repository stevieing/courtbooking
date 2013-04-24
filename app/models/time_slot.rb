class TimeSlot < ActiveRecord::Base
  
  attr_accessible :start_time, :finish_time, :slot_time, :slots
  serialize :slots, Array
  
  validates_presence_of :start_time, :finish_time, :slot_time
  validates_format_of :start_time, :finish_time, :with => /([01][0-9]|2[0-3]):[0-5][0-9]/
  validates_numericality_of :slot_time, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60
  
  before_save :create_slots
  
  private
  
  def create_slots
    write_attribute :slots, self.start_time.hhmm_to_t.to(self.finish_time.hhmm_to_t, self.slot_time.minutes)
  end

end