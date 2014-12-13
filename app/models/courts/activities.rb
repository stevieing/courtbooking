module Courts

  ###
  #
  # A utility class to manage all of the activities for a particular day.
  class Activities

    ##
    # see Closure message
    attr_reader :closure_message

    # The intializer will retrieve the following as specified by the date:
    # * The closures which will be partition them into those closures which cover all of the courts and those
    #   which don't
    # * The events.
    def initialize(slots, date, courts)
      @slots = slots
      @date = date
      @courts = courts
      @for_all_courts, @closures = Closure.partition_by_court_count(date)
      @events = Event.by_day(date)
    end

    ##
    # * add the closures for all of the courts and create a closure message.
    # * add any left over closures
    # * add any events
    def process!
      @slots.remove_slots! Slots::Slot.combine_series(@for_all_courts.slots).all
      @slots.add_activities! @closures
      @slots.add_activities! @events
      self
    end

    def closure_message
      @closure_message ||= @for_all_courts.combine(:message)
    end

  end

end