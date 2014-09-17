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

    attr_reader :court_id, :slot, :id, :cell

    delegate :from, :to, to: :slot
    delegate :text, :span, :link, :link?, :blank?, :html_class, to: :cell

    #
    # When created a CourtSlot creates a unique id.
    #
    def initialize(court_id, slot)
      @court_id, @slot = court_id, slot
      @id = CourtSlot.next_id
      @cell = Cell::NullCell.new
    end

    #
    # We don't want to fill CourtSlots that have already been filled!
    #
    def filled?
      !@cell.instance_of? Cell::NullCell
    end

    def unfilled?
      @cell.instance_of? Cell::NullCell
    end

    def inspect
      "<#{self.class}: @slot=#{@slot.inspect}, @cell=#{cell.inspect}, @id=#{@id}, @court_id=#{@court_id}>"
    end

    def fill(cell)
      @cell = cell
    end

  end
end