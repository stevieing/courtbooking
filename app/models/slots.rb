class Slots
  
  include AppConfig
  
  attr_reader :name, :value
  
  def initialize(start_time, finish_time, slot_time, name="slots")
    @name = name
    @value = create_slots(start_time, finish_time, slot_time)
    add_config
  end
  
  def create_slots(start_time, finish_time, slot_time)
    start_time.hhmm_to_t.to(finish_time.hhmm_to_t, slot_time.to_i.minutes).collect {|t| t.to_s(:hrs_and_mins)}.to_a
  end
end