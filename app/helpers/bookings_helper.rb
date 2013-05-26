module BookingsHelper
  
  def with_booking(bookings, court_number, date_and_time, &block)
    self.capture(booking_for_slot(bookings, court_number, date_and_time), &block)
  end
  
  def in_the_past?(date_and_time)
    DateTime.parse(date_and_time).in_the_past?
  end
    
  private
    
  def booking_for_slot(bookings, court_number, date_and_time)
    bookings.by_time(Time.parse(date_and_time)).by_court(court_number).first
  end
end
