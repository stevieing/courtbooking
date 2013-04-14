class TimeSlots
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :start_time, :finish_time, :slot_time
  
  validates_presence_of :start_time, :finish_time, :slot_time
  validates_format_of :start_time, :finish_time, :with => /([01][0-9]|2[0-3]):[0-5][0-9]/
  validates_numericality_of :slot_time, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 60
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def slots
    time = convert_to_time(self.start_time)
    finish = convert_to_time(self.finish_time)
    slots = [time]
    while ( time < finish) do
      time += 40*60
      slots << time
    end
    return slots
  end
  
  def persisted?
    false
  end
  
  private
  
  def convert_to_time(time)
    Time.new(01,01,01,time.split(":").first, time.split(":").last)
  end

end