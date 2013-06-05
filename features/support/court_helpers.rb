module CourtHelpers
  def days_or_weeks(arg1, arg2)
    days = arg1.to_i
    arg2.eql?("weeks") ? days*7 : days
  end
  
  def create_courts(number)
    1.upto(number) do |i|
      create(:court, number: i)
    end
  end
  
  def time_slots
    @timeslots ||= create(:time_slot)
  end
  
  def create_time_slots(attributes = nil)
    @timeslots = create(:time_slot, attributes)
  end
  
  def setup_courts
    create_courts 4
    create_time_slots
    create_setting :days_bookings_can_be_made_in_advance, {value: "21"}
  end
  
  def courts
    @courts ||= Court.all
  end
  
  def create_current_date(date)
    @current_date = date
  end
  
  def current_date
    @current_date ||= Date.today
  end
  
  def within_the_bookingslots_container(&block)
    within('#bookingslots', &block)
  end

  def within_the_calendar_container(&block)
    within('#calendar', &block)
  end
  
  def days_in_calendar(current_date, days_bookings_can_be_made_in_advance)
    current_date.to(days_bookings_can_be_made_in_advance)
  end
  
  def day_of_month(date)
    date.strftime('%d')
  end
  
  #TODO: these methods prove that the code needs to be refactored.
  def valid_booking_link
    courts.first.number.to_s + " - " + current_date.to_s(:uk) + " " + peak_hours_start_time.to_s(:hrs_and_mins)
  end
  
  def valid_time_and_place_text
    "Court: " + courts.first.number.to_s + " " + DateTime.parse(current_date.to_s(:uk) + " " + peak_hours_start_time.to_s(:hrs_and_mins)).to_s(:booking_meridian)
  end
end

World(CourtHelpers)