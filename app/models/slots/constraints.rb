module Slots
  #
  # = Slots::Constraints
  #
  # These are the constraints used by the slots
  #
  # Example:
  #  constraints = Constraints.new(slot_first: "06:30", slot_last: "10:30", slot_time: 30)
  #  constraints.series returns ["06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30"]
  #
  class Constraints

    include HashAttributes

    hash_attributes :slot_first, :slot_last, :slot_time
    attr_reader :series, :slot

    #
    # options:
    # * +slot_first+ the opening time (hh:mm)
    # * +slot_last+ the closing time (hh:mm)
    # * +slot_time+ the length of the slot (Integer)
    #
    # slot_first and slot_last will be converted to times.
    # the slot time must fit in with the first and last slot
    #
    def initialize(options)
      set_attributes_with_time(options)
      save if valid?
    end

    #
    # checks whether passed time is within the series
    #
    def cover?(time)
      @series.cover? time
    end

    def inspect
      "<#{self.class}: @slot_first=#{@slot_first}, @slot_last=#{@slot_last}, @slot_time=#{@slot_time}, @series=#{series.inspect}>"
    end

    #
    # constraints are only valid if all three options are present.
    #
    def valid?
      @slot_first && @slot_last && @slot_time
    end

    def initialize_copy(other)
      @series = other.series.dup
      super(other)
    end

  private

    def save # :nodoc:
      @slot = Slots::Slot.new(slot_first, slot_last)
      @series = Slots::Series.new(@slot, self)
    end

  end

end