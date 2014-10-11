module Slots

  ##
  #
  # = Slots::CourtSlot
  #
  #  a CourtSlot can be used to create a Court page.
  #  The unique id is useful to remove the need for lots of attributes.
  #  For example rather than passing courts/:date/:time_from/:time_to/:court_id
  #  we can pass courts/:date/:id
  #  The court slot contains the slot as well as a blank cell.
  #  This can be used to hold View information. Link, Class and Text.

  class CourtSlot

    @@id = 0

    def self.next_id
      @@id += 1
    end

    attr_reader :id, :cell, :slot, :court

    delegate :from, :to, to: :slot
    delegate :text, :span, :link, :link?, :blank?, :header?, :html_class, :remote, :to_html, to: :cell

    #
    # When created a CourtSlot creates a unique id.
    #
    def initialize(court, slot)
      @court, @slot = court, slot
      @id = CourtSlot.next_id
      @cell = Table::Cell::NullCell.new
    end

    #
    # We don't want to fill CourtSlots that have already been filled!
    #
    def filled?
      !@cell.instance_of?(Table::Cell::NullCell)
    end

    def unfilled?
      @cell.instance_of?(Table::Cell::NullCell)
    end

    def inspect
      "<#{self.class}: @cell=#{cell.inspect}, @id=#{@id}, @court_id=#{court_id}, @from=#{from}, @to=#{to}>"
    end

    def fill(c)
      @cell = c
    end

    def fill_with_booking(options)
      @cell = Table::Cell::Booking.new(options.merge(court_slot: self))
    end

    def court_id
      @court.id
    end

    def valid?
      @court && @slot
    end

  end
end