module BookingSlots

  class HeaderRow < BookingSlots::Row

    def initialize(header)
      @header = header
      @cells = create_cells
    end

    def heading?
      true
    end

  private

    def create_cells
      @header.collect { |cell| BookingSlots::Cell::Text.new(cell) }
    end

  end

end