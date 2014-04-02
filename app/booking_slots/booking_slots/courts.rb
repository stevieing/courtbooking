module BookingSlots
  class Courts

    include BookingSlots::Wrapper
    include IndexManager
    set_enumerator :courts

    attr_reader :courts

    def initialize(properties)
      @properties = properties
      @courts = Court.by_day(@properties.date)
    end

    def valid?
      @properties.valid?
    end

    def inspect
      "<#{self.class}: @index=#{@index}, @courts=#{@courts.inspect}>"
    end

    def header
      @courts.select(:number).collect { |court| "Court #{court.number.to_s}" }
    end

    def wrapper
      "&nbsp;"
    end

    def current_open?(time)
      current.opening_times.select { |court| court.slot.cover?(time) }.any?
    end

    wrap :header, :wrapper

    alias_method :all, :courts
  end
end