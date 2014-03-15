module BookingSlots
  class TodaysSlots

    include Enumerable

    attr_reader :grid
    delegate [], :up, :current_slot_time, :current_time, :current, :end?, to: :grid

    def initialize(slots, records)
      @records = records
      @records.remove_closed_slots!(slots)
      slots.freeze
      @grid = Slots::Grid.new(@records.courts.count, slots)
    end

    def each(&block)
      @grid.each(&block)
    end

    def valid?
      @grid.valid?
    end

    def skip(by)
      @grid.skip(@records.courts.index, by)
    end

    def current_datetime
      DateTime.parse("#{@records.date} #{current_slot_time}")
    end

    def current_slot_valid?
      @grid.synced?(@records.courts.index) && @records.current_court_open?(self)
    end

    def inspect
      "<#{self.class}: @grid=#{@grid.inspect}>"
    end

  end
end