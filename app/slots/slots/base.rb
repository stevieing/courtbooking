module Slots

  #
  # = Slots::Base
  #
  # This will create everything to allow the courts page to be constructed.
  # Everything that is not time sensitive is created here to improve
  # performance.
  #
  # For required parameter see Constraints.
  # To create a Grid the courts also need to be passed.
  #
  # A list of all the slots will created which can be used for such things as creating opening times.
  # A grid will be created with the slots as the rows and the courts as the columns.
  #
  #
  #
  class Base

    include Enumerable
    attr_reader :slots, :grid, :constraints
    delegate :last, to: :slots
    delegate :find_by_id, to: :grid

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

    #
    # On certain days some slots are unavailable.
    # This method will remove the offending rows and remove any slots from the overarching series
    # which is used for constructing events and closures
    #

    def remove_slots!(slot)
      @constraints.series.remove!(slot.series.popped)
      @grid.delete_rows!(slot) if @grid
    end

    #
    # One of the mainstays of this module is that the slots are stored in a constant which is then
    # used to reconstruct a page for each day. This needs to be dupped as it is manipulated.
    # For example certains slots are removed and others are filled.
    # To prevent cross contamination the constraints and the grid need to be properly copied.
    # This task is delegated to the respective class.
    #

    def initialize_copy(other)
      @constraints = other.constraints.dup
      @grid = other.grid.dup if other.grid
      super(other)
    end

    alias_method :all, :slots

  private

    def create_slots #:nodoc
      @constraints.series.collect { |slot| Slots::Slot.new(slot, nil, @constraints) }
    end
  end

end