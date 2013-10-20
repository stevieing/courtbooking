class Slots
  
  include AppConfig
  
  attr_reader :name, :value
  
  #there must be a a better way to do this?
  def initialize(start_time, finish_time, slot_time = Rails.configuration.slot_time, config = false, name="slots")
    @name = name
    if start_time.nil? || finish_time.nil? || slot_time.nil?
      @value = nil
    else
      @value = create_slots(start_time, finish_time, slot_time)
    end
    add_config if config
  end
  
  def create_slots(start_time, finish_time, slot_time)
    start_time.hhmm_to_t.to(finish_time.hhmm_to_t, slot_time.to_i.minutes).collect {|t| t.to_s(:hrs_and_mins)}.to_a
  end
  
  class << self
    
    def settings
      [:courts_opening_time, :courts_closing_time, :slot_time]
    end
    
    def valid_settings(setting = nil)
      return true if setting.nil?
      settings.include? setting.name.to_sym
    end
    
    def create(setting = nil)
      if valid_settings(setting)
        Slots.new(Setting.by_name("courts_opening_time"), Setting.by_name("courts_closing_time"), Setting.by_name("slot_time"), true)
      end
    end
  end
  
end

