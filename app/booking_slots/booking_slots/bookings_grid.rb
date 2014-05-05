#
#  TODO: This has undergone a partial refactor to modify the way cells are created.
#  The next stage is to improve the way the table is built and abstract out
#  some of the behaviour.
#

module BookingSlots
  class BookingsGrid

    attr_reader :rows, :records, :properties, :todays_slots
    delegate :last, to: :rows
    delegate :closure_message, to: :records
    delegate :user, to: :properties
    delegate :skip, to: :todays_slots

    class Rows
      include BookingSlots::Container
    end

    def initialize(date, user, slots)
      @date, @slots = date, slots
      @properties = Properties.new(date, user)
      @records = Records.new(@properties)
      @todays_slots = TodaysSlots.new(slots.dup, @records)
      @rows = create_rows
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
      Row.new(heading: true) do |row|
        @records.courts.header.each do |cell|
          row.add Cell::Text.new(cell)
        end
      end
    end

    def create_rows
      build_cells(Rows, {}, header, @todays_slots.master) do
        new_row
      end
    end

    def new_row
      build_cells(Row, {klass: row_klass}, wrapper, @records.courts) do
        Cell.build(@todays_slots.slot_type, self)
      end
    end

    def build_cells(model, args, wrapper, enumerator, &block)
      model.new(args) do |cells|
        cells.add wrapper
        until enumerator.end?
          cells.add block.call
          enumerator.up
        end
        cells.add wrapper
        enumerator.reset!
      end
    end

    def row_klass
      @todays_slots.current_datetime.in_the_past? ? "past" : nil
    end

    def wrapper
      Cell::Text.new(@todays_slots.master.current_slot_time)
    end

  end
end