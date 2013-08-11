class Setting < ActiveRecord::Base
  
  include AppConfig
  
  validates_presence_of :name, :value, :description
  validates_uniqueness_of :name
  validates_format_of :name, :with => /\A[a-zA-Z_]+\z/
 
  after_save :add_config
  
  
  
  class << self
    
    def by_name(name)
      record = where(:name => name)
      record.empty? ? nil : record.first.value
    end
  end
  
  #TODO: This all needs to be abstracted out.
  after_save :create_slots, :if => :valid_slot_settings
  
  private
  
  def create_slots
    Slots.new(Setting.by_name("start_time"), Setting.by_name("finish_time"), Setting.by_name("slot_time"))
  end
  
  def valid_slot_settings
    (self.name == "slot_time" || self.name == "start_time" || self.name == "finish_time") &&
    !(Setting.by_name("slot_time").nil? || Setting.by_name("start_time").nil? || Setting.by_name("finish_time").nil?)
  end
  
end