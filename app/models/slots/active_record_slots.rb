module Slots

  ###
  #
  # Adds a slot to various ActiveRecord models
  # mainly bookings and activities.
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
      define_method :slot= do |slot|
        @slot = slot
      end
     end
    end

    ##
    # If the record is an activity it will span several slots.
    # When we are building the courts table or getting closures for all courts
    # we either need to know how many slots the activity spans or how many slots
    # to remove.
    # For this purpose we need to build a series for which we need the slot time
    # hence why the activity slot needs constraints added.
    def create_slot
      options = {object: self}
      options.merge!(constraints: Settings.slots.constraints) if self.respond_to?(:type)
      Slots::Slot.new(options)
    end

  end
end