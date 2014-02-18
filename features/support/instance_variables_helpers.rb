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
      days_bookings_can_be_made_in_advance: lambda { Settings.days_bookings_can_be_made_in_advance },
      max_peak_hours_bookings_weekly: lambda { Settings.max_peak_hours_bookings_weekly },
      max_peak_hours_bookings_daily: lambda { Settings.max_peak_hours_bookings_daily },
      current_booking: lambda { create(:booking) },
      current_bookings: lambda { create_list(:booking, 4) },
      courts: lambda { Court.all },
      booking_slots: lambda{ Settings.slots.dup},
      slot_time: lambda { Settings.slot_time},
      dates: lambda { DateTimeHelpers::Utils.new(Date.today.to_s(:uk), "19:00")},
      settings: lambda {Setting.all},
      setting: lambda {Setting.first},
      users: lambda {User.all},
      user: lambda {User.first},
      court_opening_type: lambda{ :court_with_opening_and_peak_times },
      new_court_number: lambda{ Court.next_court_number },
      current_court: lambda { Court.first },
      standard_email_address: lambda { build(:user).email },
      current_closure: lambda { build(:closure)},
      current_activity: lambda { build(:activity)},
      current_count: lambda { 1 },
      closure_details: lambda {{}}
    }
  end
  
  def setup_instance_variables
    
    current_variables.each do |key, value|
      setup_instance_variable key, &value
    end
 
  end
  
end

World(InstanceVariablesHelpers)

