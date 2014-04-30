##
# This is the main class of the slots module.
# It will create an array of slots based on a start and end slot
# and a slot time.
# See Constraints for more info on attributes.
#

module Slots
  class Base

    include IndexManager
    set_enumerator :slots

    attr_reader :constraints
    delegate :slot_time, to: :constraints

    def initialize(options = {})
      @constraints = Slots::Constraints.new(options)
      @slots = create_slots
      @frozen = false
    end

    ##
    # The following five methods are used as comparisons.
    # See RangeChecker for more details.
    #

    def collect_range(slot)
      Slots::RangeChecker.new(slot, self).collect
    end

    def reject_range(slot)
      Slots::RangeChecker.new(slot, self).reject
    end

    def reject_range!(slot)
      Slots::RangeChecker.new(slot, self).reject!
    end

    def slots_between(slot)
      Slots::RangeChecker.new(slot, self).slots_between
    end

    ##
    # Create the next valid slot based on the current date and time
    # Mainly used for testing purposes.
    #

    def valid_slot
      Slots::Slot.new(@constraints.series.find{ |slot| slot.in_the_future?}, nil, @constraints)
    end

    #
    # There are two ways to dup the slots.
    # Either you will want to create a whole new heap of slots or used the
    # existing list.
    # For example if a whole lot of slots are not being used and you need
    # remember this freezing the slots will ensure this.
    #

    def freeze
      @frozen = true
    end

    def frozen?
      @frozen
    end

    def current_slot_time
      current.from
    end

    def current_time
      current.from.to_datetime
    end

    def inspect
      "<#{self.class}: @slots=#{@slots.each { |s| s.inspect}}, @frozen=#{@frozen}>"
    end

    alias_method :all, :slots

    #
    # When using dup and clone ruby only copies instance variables
    # so whatever you do using the bang operator will change everything
    # down the chain.
    # reset will ensure that the current slot is not remembered
    # by the dupped slots
    #
    def initialize_copy(other)
      @slots = other.frozen? ? other.slots.dup : create_slots
      reset!
      super(other)
    end

    def valid?
      @constraints.valid? && @slots.any?
    end

    private

    #
    # Builds an array of slots from the series created by the constraints.
    # The series only contains the time the slot starts.
    # The time the slot ends is useful for creating a booking.
    # This is created using the slot time.
    # It means we don't have to create this outside the module.
    #

    def create_slots
      @constraints.series.collect { |slot| Slots::Slot.new(slot, nil, @constraints) }
    end
  end

end