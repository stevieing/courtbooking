module BookingSlots
  class Calendar

    include Enumerable

    attr_reader :rows, :dates

    def initialize(attributes)
      @dates = BookingSlots::Dates.new(attributes)
      reset_cells
      @rows = create_rows
    end

    def each(&block)
      @rows.each(&block)
    end

    def header
      BookingSlots::HeaderRow.new(@dates.header)
    end

    def heading
      @dates.date_from.calendar_header(@dates.last)
    end

  private

    def create_rows
      [].tap do |rows|
        until @dates.end?
          @cells << add_cell
          add_row(rows) if new_row?
          @dates.up
        end
      end.cap(header)
    end

    def new_row?
      ( @cells.count % @dates.split == 0 ) || @dates.last?
    end

    def reset_cells
      @cells = []
    end

    def add_cell
      BookingSlots::Cell::CalendarDate.new(@dates.current_record, @dates.current_date)
    end

    def add_row(rows)
      rows << BookingSlots::Row.new(@cells)
      reset_cells
    end

  end
end