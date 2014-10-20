module Courts

  #
  # = Courts::Activities
  #
  # This class will:
  # * retrieve the closures and split out closures which relate to all courts.
  # * retrieve the events.
  #
  # The main method process! will:
  # * add the closures for all of the courts and create a closure message.
  # * add any left over closures
  # * add any events
  #

  class Activities

    attr_reader :closure_message

    def initialize(slots, date, courts)
      @slots = slots
      @date = date
      @courts = courts
      @for_all_courts, @closures = Closure.by_day(date).partition { |closure| closure.courts.count == no_of_courts }
      @events = Event.by_day(date)
    end

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

    def set_closures_for_all_courts #:nodoc
      "".tap do |message|
        @for_all_courts.each do |closure|
          @slots.remove_slots! closure.slot
          message << closure.message
        end
      end
    end

  end

end