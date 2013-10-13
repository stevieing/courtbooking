module BookingsHelper
  
  def with_booking(bookings, booking, &block)
    self.capture(booking_for_slot(bookings, booking), &block)
  end
  
  def in_the_past?(booking)
    DateTime.parse(booking.playing_on.to_s(:uk) + " " + booking.playing_from).in_the_past?
  end
  
  def new_booking_link(booking)
    link_to booking.link_text, 
    court_booking_path(booking.playing_on, booking.playing_from, booking.playing_to, booking.court_number.to_s), remote: true
	end

  private
    
  def booking_for_slot(bookings, booking)
    bookings.by_time(booking.playing_from).by_court(booking.court_number).first
  end

end
