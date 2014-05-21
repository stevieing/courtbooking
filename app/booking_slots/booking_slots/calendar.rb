#
# TODO: This has also undergone a partial refactor.
# I think it is now possible to start extracting the behaviour from the calendar and table
# into a separate module.
#

module BookingSlots
  class Calendar

    attr_reader :rows, :dates

    class Rows
      include BookingSlots::Container
    end

    def initialize(attributes)
      @dates = Dates.new(attributes)
      @rows = create_rows
    end

    def header
      Row.new(heading: true) do |row|
        dates.header.each do |cell|
          row.add Cell::Text.new(cell)
        end
      end
    end

    def heading
      dates.date_from.calendar_header(dates.last)
    end

  private

    def create_rows
      Rows.new do |rows|
        rows.add header
        loop do
          rows.add new_row
          break if dates.end?
        end
        dates.reset!
      end
    end

    def new_row
      Row.new do |row|
        loop do
          row.add new_cell
          dates.up
          break if dates.split?
        end
      end
    end

    def new_cell
      Cell.build(dates.current_record, dates.current_date)
    end

  end
end