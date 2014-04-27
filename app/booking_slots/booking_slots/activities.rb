module BookingSlots
  class Activities

    attr_reader :events, :closures

    def initialize(properties)
      @properties = properties
      @events = Event.by_day(@properties.date)
      @closures = Closure.by_day(@properties.date)
    end

    def current_record(courts, slots)
      get_activity(@closures, courts.current, slots) || get_activity(@events, courts.current, slots)
    end

    def current_activity(courts, slots)
      get_activity(@closures, courts.current, slots) || get_activity(@events, courts.current, slots)
    end

    def inspect
      "<#{self.class}: @events=#{@events.inspect}, @activities=#{@activities.inspect}>"
    end

    def valid?
      @properties.valid?
    end

  private

    def html_klass(activity)
      activity.class.to_s.downcase
    end

    def get_activity(activities, court, slots)
      activities.select { |activity| activity.court_ids.include?(court.id) && activity.time_from == slots.current.from }.first
    end

  end
end