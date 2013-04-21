class TimeSlot < ActiveRecord::Base
  
  attr_accessible :start_time, :finish_time, :slot_time, :slots
  serialize :slots, Array
  
  validates_presence_of :start_time, :finish_time, :slot_time
  validates_format_of :start_time, :finish_time, :with => /([01][0-9]|2[0-3]):[0-5][0-9]/
  validates_numericality_of :slot_time, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60
  
  before_save :create_slots
  
  private
  
    def create_slots
      time = convert_to_time(read_attribute(:start_time))
      finish = convert_to_time(read_attribute(:finish_time))
      slots = [time]
      while ( time < finish) do
        time += read_attribute(:slot_time)*60
        slots << time
      end
      write_attribute(:slots, slots)
    end
  
    def convert_to_time(time)
      Time.new(01,01,01,time.split(":").first, time.split(":").last)
    end
  
end