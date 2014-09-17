class CourtsTable

  attr_reader :slots, :closure_message
  delegate :grid, to: :slots
  delegate :find, :rows, to: :grid

  def initialize(date, user, slots)
    @date, @user, @slots = date, user, slots

    set_closures_for_all_courts
    add_closed_slots
    add_activities
    add_bookings
    fill_empty_cells_with_new_bookings
    add_class_to_rows_in_the_past
  end

  def heading
    date.to_s(:uk)
  end

private

  attr_reader :date, :user

  def set_closures_for_all_courts
    @closure_message = ""
    Court.closures_for_all_courts(date).each do |closure|
      slots.remove_slots! closure.slot
      @closure_message << closure.message
    end
  end

  def add_closed_slots
    slots.grid.courts.each do |court|
      court.opening_times.by_day(date.cwday-1).each do |opening_time|
        slots.constraints.series.except(opening_time.slot.series).each do |time|
          find(time, court.id).fill(Slots::Cell::Closed.new)
        end
      end
    end
  end

  def add_activities
    [Closure, Event].each do |model|
      model.by_day(date).each do |activity|
        activity.slot.series.popped.each_with_index do |time, index|
          activity.courts.each do |court|
            slot = find(time, court.id)
            if slot
              unless slot.filled?
                slot.fill(index == 0 ? Slots::Cell::Activity.new(activity) : Slots::Cell::Blank.new)
              end
            end
          end
        end
      end
    end
  end

  def add_bookings
    Booking.by_day(date).each do |booking|
      find(booking.time_from, booking.court.id).fill(Slots::Cell::Booking.new(booking, user))
    end
  end

  def fill_empty_cells_with_new_bookings
    slots.grid.unfilled do |empty|
      empty.fill(Slots::Cell::Booking.new(Booking.new do |booking|
        booking.date_from = date
        booking.time_from = empty.from
        booking.time_to = empty.to
        booking.court_id = empty.court_id
      end, user))
    end
  end

  def add_class_to_rows_in_the_past
    grid.rows.select do |k,v|
      date <= Date.today &&
      k <= Time.now.to_s(:hrs_and_mins) unless k.is_a? Symbol
    end.each { |k, row| row.html_class = "past" }
  end

end