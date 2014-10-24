module Slots

  #
  # a CourtSlot can be useful when create a Court page.
  # The unique id is useful to remove the need for lots of attributes.
  # For example rather than passing courts/:date/:time_from/:time_to/:court_id
  # we can pass courts/:date/:id
  # The court slot contains the slot.
  #

  class CourtSlot

    @@id = 0
    @@slots = {}

    def self.next_id
      @@id += 1
    end

    #
    # Add the newly created court slot to a hash
    # to allow for future retrieval.
    #
    def self.add(slot)
      @@slots[slot.id] = slot
    end

    #
    # Find a court slot based on its id
    #
    def self.find(id)
      @@slots[id]
    end

    attr_reader :id, :slot, :court
    delegate :from, :to, to: :slot

    #
    # When created a CourtSlot creates a unique id.
    #
    def initialize(court, slot)
      @court, @slot = court, slot
      @id = CourtSlot.next_id
      CourtSlot.add(self)
    end

    def court_id
      court.id
    end

    def valid?
      court && slot
    end

  end

end