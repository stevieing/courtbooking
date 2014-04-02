module Slots
  class Slot
    include Comparable

    attr_reader :from, :to, :series
    delegate :all, :cover?, to: :series

    def initialize(from, to, constraints = NullObject.new)
      @from, @to, @constraints = from, to, constraints
      save if valid?
    end

    def valid?
      @from && ( @to || ( @constraints.valid? && @constraints.cover?(@from)))
    end

    def <=>(other)
      @from <=> other.from && @to <=> other.to
    end

    def to_a
      [@from, @to]
    end

    def between
      ( @series.nil? ? to_a.compact.count : @series.count ) - 1
    end

    def inspect
      "<#{self.class}: @from=#{@from}, @to=#{@to} @series=#{@series.inspect}>"
    end

    private

    def save
      @to = set_to if @to.nil?
      @series = Slots::Series.new(self, @constraints)
    end

    def set_to
      @from.time_step(@constraints.slot_time)
    end

  end

end