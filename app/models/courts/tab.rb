module Courts

  #
  # = Courts::Tabe
  #
  #  This will take a copy of the slots and turn it into something ready to be
  #  output to HTML.
  #  Arguments:
  #  * date: The date on which the courts need to be viewed.
  #  * user: This is necessary to ensure that the correct permissions are applied.
  #    So that the user can add or edit a booking.
  #  * slots: Instance of Slots::Base. This must be dupped to ensure there is no
  #    cross contamintaion.
  #
  #  The initializer will:
  #  * add a html safe heading which is the date the courts are viewed.
  #  * remove any slots for which all of the courts are closed and add an appropriate
  #    message
  #  * Add any closures, events and bookings.
  #  * Fill any leftover slots with a link to add a new booking.
  #  * add a class to any rows to indicate whether they are in the past.
  #

  class Tab

    attr_reader :slots, :activities
    delegate :grid, to: :slots
    delegate :closure_message, to: :activities
    delegate :find, :rows, :heading, to: :grid

    def initialize(date, user, slots)

      @date = date
      @user = user
      @slots = slots

      slots.grid.table.heading = date.to_s(:uk)
      slots.close_court_slots! date.cwday-1
      @activities = Courts::Activities.new(slots, date, slots.grid.courts).process!
      slots.add_bookings! Booking.by_day(date), user, date
      add_class_to_rows_in_the_past

    end

    def valid?
      @date && @user && @slots
    end

    def html_class
      "tab"
    end

  private

    attr_reader :date, :user

    def add_class_to_rows_in_the_past #:nodoc
      rows.select do |k,v|
        in_the_past? k
      end.each { |k, row| row.html_class = "past" }
    end

    def in_the_past?(time) #:nodoc
      date <= Date.today && time <= Time.now.to_s(:hrs_and_mins) unless time.is_a? Symbol
    end

  end
end