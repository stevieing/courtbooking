module CourtHelpers
  
  def create_courts(number)
   create_list(court_opening_type, number)
  end
  
  def setup_courts
    create_standard_settings
    create_courts 4
    @slots = TimeSlotsHelpers::Slots.new
  end

  def within_the_bookingslots_container(&block)
    within('#bookingslots', &block)
  end

  def within_the_calendar_container(&block)
    within('#calendar', &block)
  end
  
  def valid_time_and_place_text(booking)
    "Court: " + courts.first.number.to_s + " " + booking.time_and_place_text
  end
end

World(CourtHelpers)