class Slots
  
  include AppConfig
  
  attr_reader :name, :value

  def initialize(start_time, finish_time, slot_time, name="slots")
    @name = name
    if start_time.nil? || finish_time.nil? || slot_time.nil?
      @value = nil
    else
      @value = create_slots(start_time, finish_time, slot_time)
    end
    add_config
  end
  
  def create_slots(start_time, finish_time, slot_time)
    start_time.hhmm_to_t.to(finish_time.hhmm_to_t, slot_time.to_i.minutes).collect {|t| t.to_s(:hrs_and_mins)}.to_a
  end
  
  class << self
    
    def settings
      [:start_time, :finish_time, :slot_time]
    end
    
    def valid_settings(setting = nil)
      return true if setting.nil?
      settings.include? setting.name.to_sym
    end
    
    def create(setting = nil)
      if valid_settings(setting)
        Slots.new(Setting.by_name("start_time"), Setting.by_name("finish_time"), Setting.by_name("slot_time"))
      end
    end
  end
  
end

