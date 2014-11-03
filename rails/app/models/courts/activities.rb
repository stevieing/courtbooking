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
      @for_all_courts, @closures = Closure.by_day(date).partition { |closure| closure.courts.count == no_of_courts }
      @events = Event.by_day(date)
    end

    ##
    # * add the closures for all of the courts and create a closure message.
    # * add any left over closures
    # * add any events
    def process!
      @closure_message = set_closures_for_all_courts
      @slots.add_activities! @closures
      @slots.add_activities! @events
      self
    end

  private

    def no_of_courts
      @no_of_courts ||= @courts.count
    end

    def set_closures_for_all_courts
      "".tap do |message|
        @for_all_courts.each do |closure|
          @slots.remove_slots! closure.slot
          message << closure.message
        end
      end
    end

  end

end