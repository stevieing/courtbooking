module BookingSlots
	class Calendar

    include Enumerable
    include BookingSlots::Wrapper

    attr_reader :rows, :dates

		def initialize(date_from, current_date, no_of_days, split=7)
      @dates = BookingSlots::Dates.new(date_from, current_date, no_of_days, split)
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
          add_row(rows) if @cells.count % @dates.split == 0
          @dates.up
        end
      end
    end

    def reset_cells
      @cells = []
    end

    def add_cell
      BookingSlots::Cell.new.tap { |cell| cell.add(@dates.current_record) }
    end

    def add_row(rows)
      rows << BookingSlots::Row.new(@cells)
      reset_cells
    end

    cap :create_rows, :header
	end
end