module Slots

  ##
  # A slot will only be fully created if it has valid attributes.
  # There are different types of slot depending on its usage.
  # For example:
  # If a slot is related to an activity the series is a range
  # whereas if the slot is needed for the courts page or a booking
  # The range only includes a from and a to.
  class Slot
    include Comparable
    include HashAttributes
    include Slots::Helpers

    hash_attributes from: nil, to: nil, object: nil, constraints: Slots::NullConstraints.new

    attr_reader :series, :type
    delegate :all, :cover?, :between, to: :series

    ##
    # This method will take an array of slots and combine each series
    # into a single series.
    # If there are no slots then a NullSeries is returned.
    def self.combine_series(slots)
      Series.combine(slots.collect { |slot| slot.series }) || Slots::NullSeries.new
    end

    ##
    # A slot will only be fully created if it has valid attributes.
    def initialize(options = {})
      set_attributes(options)
      save if valid?
    end

    #
    # For a slot to be valid. It either needs:
    #  * a from value with constraints so to can be created where the from value is
    #    within the from and to of the constraints.
    #  * a from and to value
    #  * an object which will contain a from and to value
    def valid?
      @object || (@from && ( @to || ( @constraints.valid? && @constraints.cover?(@from))))
    end

    #
    # Two slots are equal if their from and to are equal.
    def <=>(other)
      @from <=> other.from && @to <=> other.to
    end

    #
    # Used to create the range if there is only a from and a to.
    def to_a
      [@from, @to]
    end

    ##
    # Example:
    #  slot = Slot.new(from: "07:00", to: "09:00", constraints: <#slot_time: 30>)
    #  slot.inspect =>
    #  <# Slots::Slot @from: "07:00", @to: "09:00", series: @series.inspect >
    def inspect
      "<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
    end

    ##
    # If the slot is instantiated from an object then the object
    # will determine the type, otherwise it will be :basic
    def type
      @type ||= if @object
        @object.class_to_sym
      else
        :basic
      end
    end

    ##
    # Is it an activity
    def activity?
      type == :closure || type == :event
    end

    #
    # If the slot is an activity and it is not the last slot of the day then it will need to be adjusted
    # downwards by the slot time.
    # Otherwise just return to.
    def adjusted_to
      activity? && !constraints.covers_last?(self) ? @to.time_step_back(@constraints.slot_time) : @to
    end

  private

    #
    # The creation of the slot. Only happens if the slot attributes are valid.
    # to is created if it is nil.
    # A series is created which is useful for comparing slots.
    # If slot is instantiated with an object then from and to are inferred
    # from object.
    def save
      if @object
        @from, @to = @object.time_from, @object.time_to
      else
        @to = set_to if @to.nil?
      end
      @series = Slots::Series.new(self, @constraints)
    end

    #
    # Example:
    #  from: "06:00", slot_time: 40, to = "06:40"
    def set_to
      @from.time_step(@constraints.slot_time)
    end

  end

end