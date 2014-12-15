module Slots

  #
  # a CourtSlot can be useful when create a Court page.
  # The unique id is useful to remove the need for lots of attributes.
  # For example rather than passing courts/:date/:time_from/:time_to/:court_id
  # we can pass courts/:date/:id
  # The court slot contains the slot.
  class CourtSlot

    include ActiveModel::Serializers::JSON
    include Comparable

    ##
    # A variable to keep a record of each id created.
    @@id = 0

    ##
    # Create the next id for a new court slot.
    # This is an autonumber
    def self.next_id
      @@id += 1
    end

    #
    # Find a court slot based on its id
    def self.find(id)
      @@slots[id]
    end

    attr_reader :id, :slot, :court
    delegate :from, :to, to: :slot

    #
    # When created a CourtSlot creates a unique id.
    def initialize(court, slot)
      @court, @slot = court, slot
      @id = CourtSlot.next_id
    end

    ##
    # id of the court attribute.
    def court_id
      court.id
    end

    ##
    # A court slot is valid if its court and slot are valid.
    def valid?
      court && slot
    end

    def inspect
      "<#{self.class}: @id=#{id}, @from=#{from}, @to=#{to}, @court_id=#{court_id}>"
    end

    ##
    # Two court slots are equal if their slots are equal and the courts
    # have the same id.
    def <=>(other)
      slot <=> other.slot && court_id <=> other.court_id
    end

    ##
    # court_slot = <#Slots::CourtSlot @id: 1, @from: "08:20", @to: "09:00", @court_id: 10>
    # court_slot.to_json produces:
    #  { court_slot:
    #     {
    #       id: 1,
    #       from: "08:20",
    #       to: "09:00",
    #       court_id: 10
    #      }
    #  }
    def as_json(options = {})
      {
        court_slot: {
          id: id,
          from: from,
          to: to,
          court_id: court_id
        }
      }
    end

  end

end