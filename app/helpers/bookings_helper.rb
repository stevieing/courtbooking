module BookingsHelper
  
  def with_booking(bookings, court_number, playing_at, &block)
    self.capture(booking_for_slot(bookings, court_number, playing_at), &block)
  end
  
  def in_the_past?(playing_at)
    DateTime.parse(playing_at).in_the_past?
  end
    
  private
    
  def booking_for_slot(bookings, court_number, playing_at)
    bookings.by_time(Time.parse(playing_at)).by_court(court_number).first
  end
end
