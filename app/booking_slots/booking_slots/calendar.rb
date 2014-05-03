#
# TODO: This has also undergone a partial refactor.
# I think it is now possible to start extracting the behaviour from the calendar and table
# into a separate module.
#

module BookingSlots
  class Calendar

    include Enumerable

    attr_reader :rows, :dates

    def initialize(attributes)
      @dates = BookingSlots::Dates.new(attributes)
      @rows = create_rows.cap(header)
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
          rows << BookingSlots::Row.new(create_cells)
        end
        @dates.reset!
      end
    end

    def create_cells
      [].tap do |cells|
        loop do
          cells << BookingSlots::Cell.build(@dates.current_record, @dates.current_date)
          @dates.up
          break if @dates.split?
        end
      end
    end

  end
end