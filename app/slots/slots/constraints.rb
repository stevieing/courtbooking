module Slots
  class Constraints

    include HashAttributes

    hash_attributes :slot_first, :slot_last, :slot_time
    attr_reader :series, :slot

    def initialize(options)
      set_attributes_with_time(options)
      save if valid?
    end

    def cover?(time)
      @series.cover? time
    end

    def inspect
      "<#{self.class}: @slot_first=#{@slot_first}, @slot_last=#{@slot_last}, @slot_time=#{@slot_time}, @series=#{series.inspect}>"
    end

    def valid?
      @slot_first && slot_last && @slot_time
    end

  private

    def save
      @slot = Slot.new(slot_first, slot_last)
      @series = Series.new(@slot, self)
    end

  end

end