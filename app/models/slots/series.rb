module Slots

  ##
  # = Slots::Series
  #
  # A Series allow comparison and validation of slots.
  # It can also be used to fill Cells for views especially for slots
  # which cover a range.
  #
  class Series
    include Enumerable
    include Slots::Helpers
    include Comparable

    attr_reader :range

    def self.combine(serieses)
      serieses.reduce(:<<)
    end

    def initialize(slot, constraints)
      @range = create_range(slot, constraints)
    end

    def each(&block)
      @range.each(&block)
    end

    alias_method :all, :range

    def inspect
      "<#{self.class}: @range=[#{@range.join(",")}]>"
    end

    #
    # Checks whether a slot is included within another
    #
    def include?(other)
      other.to_set.subset?(self.to_set)
    end

    #
    # Checks whether the time is covered by a slot.
    #
    def cover?(time)
      (@range.first..@range.last).cover?(time)
    end

    #
    # Returns range minus anything that is in other
    #
    def except(other)
      @range - other.range
    end

    #
    # Remove items from range in series
    #
    def remove!(range)
      @range -= range
    end

    def popped
      @range.take(@range.size-1)
    end

    def <<(other)
      @range.concat(other.range).uniq!
      self
    end

    def initialize_copy(other)
      @range = other.range.dup
    end

    def <=>(other)
      @range <=> other.range
    end

    def past(date)
      return range if date < Date.today
      return [] if date > Date.today
      range.reject { |time| time > Time.now.to_s(:hrs_and_mins)}
    end

  private

    def create_range(slot, constraints) # :nodoc:
      to_range(slot.from, slot.adjusted_to, constraints.slot_time) || slot.to_a
    end
  end
end