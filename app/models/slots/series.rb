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

    attr_reader :range

    def initialize(slot, constraints)
      @slot = slot
      @constraints = constraints
      @range = create_range
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

  private

    def create_range # :nodoc:
      if @constraints.valid?
        to_range(@slot.from, @slot.to, @constraints.slot_time)
      else
        @slot.to_a
      end
    end
  end
end