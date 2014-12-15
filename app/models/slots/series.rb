module Slots

  ##
  # A Series allow comparison and validation of slots.
  # It can also be used to fill Cells for views especially for slots
  # which cover a range.
  class Series
    include Enumerable
    include Slots::Helpers
    include Comparable

    attr_reader :range

    ##
    # Combine a group of series by invoking the << method.
    # The first series in the range is returned.
    def self.combine(serieses)
      serieses.reduce(:<<)
    end

    ##
    # If the constraints are valid then a series is created
    # from the from and to of the slot.
    # Each member of the series is incremented by the slot time.
    # If the constraints are not valid then the series is created
    # using the from and to of the slot.
    def initialize(slot, constraints)
      @range = create_range(slot, constraints)
    end

    ##
    # The range.
    def each(&block)
      @range.each(&block)
    end

    alias_method :all, :range

    def inspect
      "<#{self.class}: @range=[#{@range.join(",")}]>"
    end

    ##
    # Checks whether a slot is included within another.
    def include?(other)
      other.to_set.subset?(self.to_set)
    end

    ##
    # Checks whether the time is covered by a slot.
    def cover?(time)
      (@range.first..@range.last).cover?(time)
    end

    ##
    # Returns range minus anything that is in other.
    def except(other)
      @range - other.range
    end

    ##
    # Remove items from range in series.
    def remove!(range)
      @range -= range
    end

    ##
    # Remove the last item in the series.
    def popped
      @range.take(@range.size-1)
    end

    ##
    # Merge the two ranges and remove any duplicates.
    # self is returned for chaining purposes.
    def <<(other)
      @range.concat(other.range).uniq!
      self
    end

    ##
    # dup will dup the range.
    def initialize_copy(other)
      @range = other.range.dup
    end

    ##
    # Two series are equal if their ranges a are equal.
    def <=>(other)
      @range <=> other.range
    end

    ##
    # This will return any items in the series which are in the past.
    #  * If the date is before today all items in the series are returned.
    #  * If the date is after today an empty array is returned.
    #  * If the date is today any items in the current series
    #    which are before the current time are returned.
    def past(date)
      return range if date < Date.today
      return [] if date > Date.today
      range.reject { |time| time > Time.now.to_s(:hrs_and_mins)}
    end

  private

    def create_range(slot, constraints)
      to_range(slot.from, slot.adjusted_to, constraints.slot_time) || slot.to_a
    end
  end
end