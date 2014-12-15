module Slots

  ##
  # Court Slots hold information about the available courts and slots.
  # This information is available to create a table.
  # It is also available to allow retrieval of CourtSlot information
  # through an id which prevents times being passed through urls.
  #
  # On creation a CourtSlot is created for all combinations of courts and slots.
  # Plus a table of empty cells is created each relating to a CourtSlot
  #
  # Example:
  #  slots = <#Slots::Base @slots = [<#Slot1: @from="06:20">, <#Slot2: @from="07:00">]
  #  courts = [<#Court1: @id="1>, <#Court2: @id="2>]
  #  court_slots = CourtSlots.new(slots, courts)
  #  =>
  #   <#Slots:CourtSlots:
  #    @court_slots = { 1: <#CourtSlot1>, 2: <#CourtSlot2>, 3: <#CourtSlot3>, 4: <#CourtSlot4> }
  #    @table = <#Table::Base @rows =
  #    { "06:20": <#Table::Row: @cells= { 1: <#CourtSlot1>, 2: <#CourtSlot2>}
  #    { "07:00": <#Table::Row: @cells= { 1: <#CourtSlot3>, 2: <#CourtSlot4>} }
  #
  class CourtSlots

    include Enumerable

    attr_reader :table

    delegate :find, to: :table

    def initialize(courts, slots)
      @court_slots = {}
      @table = create_table(courts, slots)
    end

    ##
    # A valid instance if any court slots have been created.
    def valid?
      court_slots.any?
    end

    ##
    # Return an array of all of the current slots.
    def all
      court_slots
    end

    ##
    # each CourtSlot.
    def each(&block)
      court_slots.each(&block)
    end

    ##
    # Find a court slot by its id.
    def find_by_id(id)
      court_slots[id]
    end

    ##
    # This will take a copy of the table
    # and convert each cell to an empty cell.
    def to_empty
      table.dup.tap do |t|
        t.rows.each do |r, row|
          row.each do |c, cell|
            row.fill(c, Table::Cell::Empty.new(cell))
          end
        end
      end
    end

  private

    attr_reader :court_slots

    def create_table(courts, slots)
      Table::Base.new do |t|
        slots.each do |slot|
          t.add slot.from, new_row(courts, slot)
        end
      end
    end

    def new_row(courts, slot)
      Table::Row.new do |r|
        courts.each do |court|
          r.add court.id, add_court_slot(court, slot)
        end
      end
    end

    def add_court_slot(court, slot)
      CourtSlot.new(court, slot).tap do |court_slot|
        @court_slots[court_slot.id] = court_slot
      end
    end

  end

end