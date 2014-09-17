module Slots
  class Base

    include Enumerable
    attr_reader :slots, :grid, :constraints
    delegate :last, to: :slots

    def initialize(options = {})
      @constraints = Slots::Constraints.new(options)
      @slots = create_slots
      @grid = Grid.new(@slots, options[:courts]) if options[:courts]
    end

    def each(&block)
      @slots.each(&block)
    end

    def inspect
      "<#{self.class}: @slots=#{@slots.each { |s| s.inspect}}, @grid=#{@grid.each { |g| g.inspect}}>"
    end

    def valid?
      @constraints.valid? && @slots.any?
    end

    def remove_slots!(slot)
      @constraints.series.remove!(slot.series.popped)
      @grid.delete_rows!(slot) if @grid
    end

    def initialize_copy(other)
      @constraints = other.constraints.dup
      @grid = other.grid.dup if other.grid
      super(other)
    end

    alias_method :all, :slots

  private

    def create_slots
      @constraints.series.collect { |slot| Slots::Slot.new(slot, nil, @constraints) }
    end
  end

end