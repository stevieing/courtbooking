module InstanceVariablesHelpers
  
  def setup_instance_variable(name, &block)
    
    var, create_var = "@#{name}", "create_#{name}"
    
    self.class.class_eval do
      define_method name do
        instance_variable_set(var, block.call) if instance_variable_get(var).nil?
        instance_variable_get(var)
      end
                
      define_method create_var do |value|
        instance_variable_set(var, value)
      end
    end
      
  end
  
  def current_variables
    {
      days_bookings_can_be_made_in_advance: lambda { Rails.configuration.days_bookings_can_be_made_in_advance },
      peak_hours_start_time: lambda { Rails.configuration.peak_hours_start_time },
      peak_hours_finish_time: lambda { Rails.configuration.peak_hours_finish_time },
      max_peak_hours_bookings: lambda { Rails.configuration.max_peak_hours_bookings },
      current_booking: lambda { create(:booking) },
      current_bookings: lambda { create_list(:booking, 4) },
      courts: lambda { Court.all },
      slots: lambda { TimeSlotsHelpers::Slots.new },
      dates: lambda { DateTimeHelpers::Utils.new(Date.today.to_s(:uk), "19:00")},
      settings: lambda {Setting.all},
      setting: lambda {Setting.first}
    }
  end
  
  def setup_instance_variables
    
    current_variables.each do |key, value|
      setup_instance_variable key, &value
    end
 
  end
  
end

World(InstanceVariablesHelpers)

