module Slots
  class RangeChecker
    def initialize(slot, slots)
      @slot, @slots = slot, slots
    end

    def collect
      @slots.all.find_all { |slot| superset_of? slot}
    end

    def reject
      @slots.all.reject { |slot| superset_of? slot}
    end

    def reject!
      @slots.all.reject! { |slot| superset_of? slot}
      @slots.reset_count
    end

    def slots_between
      collect.count
    end

    def superset_of?(slot)
      @slot.series.include? slot.series
    end
  end
end