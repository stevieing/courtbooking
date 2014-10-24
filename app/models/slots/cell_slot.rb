module Slots

  ###
  #
  #  a CellSlot can be used to create a Court page.
  #  The cell slot will create a new CourtSlot and an Empty Cell
  #  This can be used to hold View information. Link, Class and Text.
  #

  class CellSlot

    attr_reader :cell, :slot

    delegate :from, :to, :id, :court_id, to: :slot
    delegate :text, :span, :link, :link?, :blank?, :header?, :closed?, :empty?, :html_class, :remote, :to_html, to: :cell

    #
    # When created a CellSlot creates a unique id.
    #
    def initialize(court, slot)
      @slot = CourtSlot.new(court, slot)
      @cell = Table::Cell::Empty.new
    end

    #
    # We don't want to fill CellSlots that have already been filled!
    #
    def filled?
      !cell.empty?
    end

    def unfilled?
      cell.empty?
    end

    def inspect
      "<#{self.class}: @cell=#{cell.inspect}, @id=#{id}, @court_id=#{court_id}, @from=#{from}, @to=#{to}>"
    end

    def fill(c)
      @cell = c
    end

    def fill_with_booking(options)
      fill(Table::Cell::Booking.new(options.merge(court_slot: slot)))
    end

    def fill_with_activity(*args)
      fill(Table::Cell::Activity.new(*args))
    end

    def close
      fill(Table::Cell::Closed.new)
    end

    def valid?
      cell && slot
    end

    def initialize_copy(other)
      @slot = other.slot
      @cell = other.cell.dup
      super(other)
    end

  end
end