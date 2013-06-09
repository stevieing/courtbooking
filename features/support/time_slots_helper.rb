module TimeSlotsHelpers
  
  #This must be setup after DateTime is stubbed
  class Slots
    
    attr_accessor :current_slot, :slot_time, :all
    
    def initialize(attributes = nil)
      @time_slots = create(:time_slot, attributes)
      @current_slot = set_valid_slot
      @slot_time = @time_slots.slot_time
    end
    
    def all
      @time_slots.slots
    end
    
    def next
      @current_slot += 1
    end
    
    def previous
      @current_slot = in_the_past
    end
    
    def playing_from
      @time_slots.slots[current_slot]
    end
    
    def playing_to
      unless current_slot > @time_slots.slots.length - 2
        @time_slots.slots[current_slot + 1]
      else
        @time_slots.slots[@time_slots.slots.length-1]
      end
    end
    
    private
    
    def in_the_past
      slot = @time_slots.slots.find_index { |slot| Time.parse(slot).to_sec < DateTime.now.to_sec }
      slot.nil? ? @time_slots.slots.first : slot
    end
    
    def set_valid_slot
      slot = @time_slots.slots.find_index { |slot| Time.parse(slot).to_sec > DateTime.now.to_sec }
      slot.nil? ? @time_slots.slots.length-1 : slot
    end
  end
  
end

World(TimeSlotsHelpers)