module Slots
 module ActiveRecordSlots

  extend ActiveSupport::Concern

  included do
   add_slots_method
  end

  module ClassMethods
   def add_slots_method
    define_method :slot do
     @slot ||= create_slot
    end
   end
  end

  def create_slot
   constraints = self.kind_of?(Activity) ? Settings.slots.constraints : Slots::NullObject.new
   Slots::Slot.new(self.time_from, self.time_to, constraints)
  end
 end
end