module Slots
  #
  # = Slots::Constraints
  #
  # These are the constraints used by the slots.
  #  * Creates a slot where from = slot_first and to = slot_last.
  #  * Creates a series between slot_first and slot_last.
  #  * Creates a series of slots for each member of the series.
  #
  # Example:
  #  constraints = Constraints.new(slot_first: "06:30", slot_last: "10:30", slot_time: 30)
  #  constraints.series returns ["06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30"]
  class Constraints

    include HashAttributes
    include Enumerable

    hash_attributes slot_first: "00:00", slot_last: "23:59", slot_time: 40
    attr_reader :series, :slot, :slots
    delegate :last, to: :slots

    #
    # options:
    # * +slot_first+ the opening time (hh:mm)
    # * +slot_last+ the closing time (hh:mm)
    # * +slot_time+ the length of the slot (Integer)
    #
    # slot_first and slot_last will be converted to times.
    # the slot time must fit in with the first and last slot
    def initialize(options)
      set_attributes_with_time(options)
      save if valid?
    end

    ##
    # slots attribute.
    def each(&block)
      @slots.each(&block)
    end

    alias_attribute :all, :slots

    #
    # checks whether passed time is within the series
    def cover?(time)
      @series.cover? time
    end

    ##
    # checks whether the time passed is greater than the
    # last slot in the series.
    def covers_last?(slot)
      #slot.to >= slot_last.to_s(:hrs_and_mins)
      slot.to >= slot_last
    end

    ##
    # Example:
    #  constraints = Constraints.new(slot_first: "07:00", slot_last: "09:00", slot_time: 30)
    #  constraints.inspect =>
    #  <#Slots::Constraints: @slot_first="07:00", @slot_last="09:00", @slot_time=30, @series=@series.inspect>
    def inspect
      "<#{self.class}: @slot_first=#{@slot_first}, @slot_last=#{@slot_last}, @slot_time=#{@slot_time}, @series=#{series.inspect}>"
    end

    #
    # constraints are only valid if all three options are present.
    def valid?
      @slot_first && @slot_last && @slot_time
    end

    ##
    # dup will dup the series.
    def initialize_copy(other)
      @series = other.series.dup
      super(other)
    end


  private

    def save
      @slot = Slots::Slot.new(from: slot_first, to: slot_last)
      @series = Slots::Series.new(@slot, self)
      @slots = create_slots
    end

    def create_slots
      @series.collect { |slot| Slots::Slot.new(from: slot, constraints: self) }
    end

  end

end