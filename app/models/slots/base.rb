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
  #  TODO: In development if any changes are made then we get a
  #  A copy of Slots::CellSlot has been removed from the module tree but is still active!
  #  Adding a require to the settings initializer prevents this however we get an
  #  ActiveRecord::AssociationMismatch with the courts.
  #  This can be prevented by replacing b.court = @court_slot.court with b.court_id = @court_slot.court_id
  #  in Table::Cell::Booking but I would prefer to find tha actual problem.
  #  Creating the slots in the controller fixes the whole thing.
  #  There is obviously a problem with autoloading and complex constants.
  #  The next refactor will involve splitting the grid into dynamic and static sections so
  #  we can see if that alleviates the problem.
  #
  class Base

    include Enumerable
    attr_reader :slots, :grid, :constraints
    delegate :last, to: :slots
    delegate :find_by_id, :add_bookings!, :add_activities!, to: :grid

    def initialize(options = {})
      @constraints = Slots::Constraints.new(options)
      @slots = create_slots
      @grid = Slots::Grid.new(@slots, options[:courts]) if options[:courts]
    end

    def each(&block)
      @slots.each(&block)
    end

    def inspect
      "<#{self.class}: @slots=#{@slots.each { |s| s.inspect}}, @grid=#{@grid.table.each { |g| g.inspect}}>"
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

    def close_court_slots!(day)
      grid.close_court_slots! day, constraints.series
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