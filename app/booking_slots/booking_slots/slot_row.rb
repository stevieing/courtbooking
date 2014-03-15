module BookingSlots

  #
  # TODO: records is only here to pass through to CellBuilder. Need to remove it.
  # this signifies a flaw in my logic.
  #
  class SlotRow < BookingSlots::Row

    include BookingSlots::Wrapper

    def initialize(slots, records)
      @slots, @records = slots, records
      @cells = create_cells
      @klass = BookingSlots::HtmlKlass.new(@slots.current_datetime).value
    end

    private

    def wrapper
      BookingSlots::Cell.new(@slots.current_slot_time)
    end

    def create_cells
      [].tap do |cells|
        until @records.courts.end?
          cells << BookingSlots::CellBuilder.new(@slots, @records).add
          @records.courts.up
        end
        @records.courts.reset!
      end
    end

    wrap :create_cells, :wrapper

  end

end