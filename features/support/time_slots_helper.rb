require Rails.root.join("spec/support/shared/manage_settings.rb")

module TimeSlotsHelpers

  #This must be setup after DateTime is stubbed
  class Slots
    
    include ManageSettings
    
    attr_accessor :current_slot, :slot_time, :all
    
    def initialize(attributes = nil)
      create_settings(:slot_time, :start_time, :finish_time)
      @time_slots = Rails.configuration.slots
      @current_slot = set_valid_slot
      @slot_time = Rails.configuration.slot_time
    end
    
    def all
      @time_slots
    end
    
    def next
      @current_slot += 1
    end
    
    def previous
      @current_slot = in_the_past
    end
    
    def playing_from
      @time_slots[current_slot]
    end
    
    def playing_to
      unless current_slot > @time_slots.length - 2
        @time_slots[current_slot + 1]
      else
        @time_slots[@time_slots.length-1]
      end
    end
    
    private
    
    def in_the_past
      slot = @time_slots.find_index { |slot| Time.parse(slot).to_sec < DateTime.now.to_sec }
      slot.nil? ? @time_slots.first : slot
    end
    
    def set_valid_slot
      slot = @time_slots.find_index { |slot| Time.parse(slot).to_sec > DateTime.now.to_sec }
      slot.nil? ? @time_slots.length-1 : slot
    end
  end
  
end

World(TimeSlotsHelpers)