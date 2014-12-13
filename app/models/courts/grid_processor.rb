module Courts
  class GridProcessor

    attr_reader :closure_message, :table

    def initialize(date, user, grid)
      @date = date
      @user = user
      @grid = grid
      @closures_all, @closures = Closure.partition_by_court_count(date)
      @events = Event.by_day(date)
      @bookings = Booking.by_day(date)
    end

    def run!
      @closure_message ||= @closures_all.combine(:message)
      grid.close_court_slots! @date.cwday-1
      grid.remove_slots! Slots::Slot.combine_series(@closures_all.slots).all
      add_activities! @closures
      add_activities! @events
      add_bookings! @bookings, @user, @date
      grid.add_class_to_rows_in_past @date
      self
    end

    def add_activities!(activities)
      activities.each do |activity|
        activity.slot.series.all.each do |time|
          activity.courts.each do |court|
            grid.fill(time, court.id, Table::Cell::Activity.new(activity,time))
          end
        end
      end
    end

    #
    # This will add the bookings to the appropriate slots
    # and then add new bookings to the rest of them which are unfilled.
    def add_bookings!(bookings, user, date)
      grid.unfilled do |empty|
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