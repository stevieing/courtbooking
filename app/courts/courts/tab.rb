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

    attr_reader :slots, :closure_message
    delegate :grid, to: :slots
    delegate :find, :rows, :heading, :table, to: :grid

    def initialize(date, user, slots)
      @date, @user, @slots = date, user, slots

      table.heading = date.to_s(:uk)

      @closures = Closures.new(slots.grid.courts, date)

      set_closures_for_all_courts
      add_closed_slots
      add_activities closures
      add_activities Event.by_day(date)
      add_bookings
      fill_empty_cells_with_new_bookings
      add_class_to_rows_in_the_past
    end

  private

    attr_reader :date, :user, :closures

    def set_closures_for_all_courts #:nodoc
      @closure_message = ""
      closures.for_all_courts.each do |closure|
        slots.remove_slots! closure.slot
        @closure_message << closure.message
      end
    end

    def add_closed_slots #:nodoc
      slots.grid.courts.each do |court|
        court.opening_times.by_day(date.cwday-1).each do |opening_time|
          slots.constraints.series.except(opening_time.slot.series).each do |time|
            find(time, court.id).fill(Table::Cell::Closed.new)
          end
        end
      end
    end

    def add_activities(activities) #:nodoc
      activities.each do |activity|
        activity.slot.series.popped.each do |time|
          activity.courts.each do |court|
            find(time, court.id).fill(Table::Cell::Activity.new(activity, time))
          end
        end
      end
    end

    def add_bookings #:nodoc
      Booking.by_day(date).each do |booking|
        slot = find(booking.time_from, booking.court.id)
        slot.fill(Table::Cell::Booking.new(booking, user, slot))
      end
    end

    def fill_empty_cells_with_new_bookings #:nodoc
      slots.grid.unfilled do |empty|
        empty.fill(Table::Cell::Booking.new(new_booking do |booking|
          booking.date_from = date
          booking.time_from = empty.from
          booking.time_to = empty.to
          booking.court = empty.court
        end, user, empty))
      end
    end

    def add_class_to_rows_in_the_past #:nodoc
      grid.rows.select do |k,v|
        in_the_past? k
      end.each { |k, row| row.html_class = "past" }
    end

    def in_the_past?(time) #:nodoc
      date <= Date.today && time <= Time.now.to_s(:hrs_and_mins) unless time.is_a? Symbol
    end

    def new_booking #:nodoc
      @booking ||= Booking.new
      yield @booking if block_given?
      @booking
    end

  end
end