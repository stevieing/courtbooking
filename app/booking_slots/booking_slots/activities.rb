module BookingSlots
  class Activities

    attr_reader :events, :closures

    def initialize(properties)
      @properties = properties
      @events = Event.by_day(@properties.date)
      @closures = Closure.by_day(@properties.date)
    end

    def current_record(courts, slots)
      activity = current_activity(courts, slots)
      BookingSlots::CurrentRecord.create(activity) do |record|
        record.text   = activity.description
        record.span   = activity.slot.between
        record.klass  = BookingSlots::HtmlKlass.new(activity).value
      end
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

    def get_activity(activities, court, slots)
      activities.select { |activity| activity.court_ids.include?(court.id) && activity.time_from == slots.current.from }.first
    end

  end
end