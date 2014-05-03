#
#  TODO: This has undergone a partial refactor to modify the way cells are created.
#  The next stage is to improve the way the table is built and abstract out
#  some of the behaviour.
#

module BookingSlots
  class Table

    include Enumerable

    attr_reader :rows, :records, :properties
    delegate :last, to: :rows
    delegate :closure_message, to: :records
    delegate :user, to: :properties

    def initialize(date, user, slots)
      @date, @slots = date, slots
      @properties = Properties.new(date, user)
      @records = Records.new(@properties)
      @todays_slots = TodaysSlots.new(slots.dup, @records)
      @rows = create_rows.wrap(header)
    end

    def each(&block)
      @rows.each(&block)
    end

    def heading
      @properties.date.to_s(:uk)
    end

    def inspect
      "<#{self.class}: @date=#{@date}, @rows=#{@rows.each {|row| row.inspect}}>"
    end

    def valid?
      true
    end

    def current_record
      @records.current_record(@todays_slots)
    end

  private

    def header
      HeaderRow.new(@records.courts.header)
    end

    def create_rows
      build_cells(@todays_slots.master) do
        BookingSlots::Row.new(create_cells.wrap(wrapper), row_klass)
      end
    end

    def create_cells
      build_cells(@records.courts) do
        BookingSlots::Cell.build(@todays_slots.slot_type, self).tap do |cell|
          @todays_slots.skip(cell.span) if cell.active?
        end
      end
    end

    def row_klass
      @todays_slots.current_datetime.in_the_past? ? "past" : nil
    end

    def wrapper
      BookingSlots::Cell::Text.new(@todays_slots.master.current_slot_time)
    end

    def build_cells(enumerator, &block)
      [].tap do |cells|
        until enumerator.end?
          cells << block.call
          enumerator.up
        end
        enumerator.reset!
      end
    end

  end
end