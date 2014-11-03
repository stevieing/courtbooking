module Slots

  ##
  # = Slots::Slot
  #
  # A slot will only be fully created if it has valid attributes.
  # There are different types of slot depending on its usage.
  # For example:
  # If a slot is related to an activity the series is a range
  # whereas if the slot is needed for the courts page or a booking
  # The range only includes a from and a to.
  #
  class Slot
    include Comparable

    attr_reader :from, :to, :series
    delegate :all, :cover?, to: :series

    def initialize(from, to, constraints = Slots::NullObject.new)
      @from = from
      @to = to
      @constraints = constraints
      save if valid?
    end

    #
    # For a slot to be valid. It either needs:
    #  * a from value with constraints so to can be created where the from value is
    #    within the from and to of the constraints.
    #  * a from and to value
    #
    def valid?
      @from && ( @to || ( @constraints.valid? && @constraints.cover?(@from)))
    end

    #
    # Two slots are equal if their from and to are equal.
    #
    def <=>(other)
      @from <=> other.from && @to <=> other.to
    end

    #
    # Used to create the range if there is only a from and a to.
    #
    def to_a
      [@from, @to]
    end

    #
    # The number of slots between the first and the last slot in the range.
    # If there is a series it counts the number of slots between them
    # otherwise uses to_a
    #
    def between
      ( @series.nil? ? to_a.compact.count : @series.count ) - 1
    end

    def inspect
      "<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
    end

  private

    #
    # The creation of the slot. Only happens if the slot attributes are valid.
    # to is created if it is nil.
    # A series is created which is useful for comparing slots.
    #
    def save
      @to = set_to if @to.nil?
      @series = Slots::Series.new(self, @constraints)
    end

    #
    # Example:
    #  from: "06:00", slot_time: 40, to = "06:40"
    #
    def set_to
      @from.time_step(@constraints.slot_time)
    end

  end

end