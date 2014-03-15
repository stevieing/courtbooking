module BookingSlots
  class Courts

    include BookingSlots::Wrapper
    include IndexManager
    set_enumerator :courts

    attr_reader :courts

    def initialize(properties)
      @properties = properties
      @courts = Court.includes(:opening_times)
    end

    def valid?
      @properties.valid?
    end

    def inspect
      "<#{self.class}: @index=#{@index}, @courts=#{@courts.inspect}>"
    end

    def header
      Court.pluck(:number).collect { |n| "Court #{n.to_s}" }
    end

    def wrapper
      "&nbsp;"
    end

    wrap :header, :wrapper

    alias_method :all, :courts
  end
end