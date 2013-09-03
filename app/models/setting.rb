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

  after_save :create_slots
  
  private
  
  def create_slots
    Slots.create(self)
  end

end