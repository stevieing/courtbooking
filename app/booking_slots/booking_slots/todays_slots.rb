##
# It is necessary to wrap the slots in another class as they need some preprocessing.
# 1. Any slots that are unavailable through closures need to be removed.
# So they don't appear unnecessarily on the page.
# 2. Once superfluous slots are removed they are frozen
# 3. The slots need to be duplicated for each court that is open.
# As they are frozen they will not be recreated preventing unavailable slots being
# added back in.
# The class also provides some helper methods.
#
#
#
#


module BookingSlots
  class TodaysSlots

    include Enumerable

    attr_reader :grid
    delegate [], :current, :master, to: :grid

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
      DateTime.parse("#{@records.date} #{master.current_slot_time}")
    end

    def grid_synced?
      @grid.synced?(@records.courts.index)
    end

    def current_court_open?
      @records.current_court_open?(self)
    end

    def slot_type
      return :blank unless grid_synced?
      return :closed unless current_court_open?
      return :open
    end

    def inspect
      "<#{self.class}: @grid=#{@grid.inspect}>"
    end

  end
end