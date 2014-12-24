module Courts

  ##
  # It turns an empty table into one with all
  # corresponding bookings and activities for that day.
  class GridProcessor

    ##
    # A message describing why all of the courts are closed.
    attr_reader :closure_message

    ##
    # The table ready for consumption by a view.
    attr_reader :table

    ##
    # Creates all the Closures, Events and Bookings
    # for the date.
    def initialize(date, user, grid)
      @date = date
      @user = user
      @grid = grid
      @closures_all, @closures = Closure.partition_by_court_count(date)
      @events = Event.by_day(date)
      @bookings = Booking.by_day(date)
    end

    ##
    # Effectively adds everything of any significance to the table for the grid
    # and copies the table grid into a new table.
    # It will execute all of the following functions:
    # * create a single closure message from all of the closures for today.
    # * add a heading to the table which is the date.
    # * Find any times where the courts are closed and close the slots.
    # * Remove any rows from the table where all the courts are closed.
    # * Add any closures to the table.
    # * And any events to the table.
    # * Add a class to any rows which are in the past.
    # * returns self so can be chained with new.
    def run!
      @closure_message ||= @closures_all.combine(:message)
      grid.add_heading @date.to_s(:uk)
      grid.close_court_slots! @date.cwday-1
      grid.remove_slots! Slots::Slot.combine_series(@closures_all.slots).all
      add_activities! @closures
      add_activities! @events
      add_bookings! @bookings, @user, @date
      grid.add_class_to_rows_in_past @date
      @table = grid.table
      self
    end

    ##
    # For each activity fill the corresponding cell with an activity.
    def add_activities!(activities)
      activities.each do |activity|
        activity.slot.series.each do |time|
          activity.courts.each do |court|
            grid.fill(time, court.id, Table::Cell::Activity.new(activity,time))
          end
        end
      end
    end

    ##
    # This will add the bookings to the appropriate slots
    # and then add new bookings to the rest of them which are unfilled.
    def add_bookings!(bookings, user, date)
      grid.unfilled.each do |empty|
        grid.fill(empty.slot.from, empty.slot.court_id, select_booking(bookings, user, date, empty.slot))
      end
    end

  private

    attr_reader :grid

    def select_booking(bookings, user, date, slot)
      Table::Cell::Booking.new(
      bookings.select_first_or_initialize(time_from: slot.from, court: slot.court) do |booking|
        booking.date_from = date
        booking.user = user
        booking.slot = slot
      end)
    end

  end

end