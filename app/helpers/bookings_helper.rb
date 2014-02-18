module BookingsHelper
  
  def get_booking(bookings, court, slots, &block)
    self.capture(booking_by_slot(bookings, court, slots), &block)
  end
  
  def new_booking_link(booking)
    link_to booking.link_text, 
    court_booking_path(booking.playing_on, booking.time_from, booking.time_to, booking.court_number.to_s), remote: true
	end

  def new_booking(court, slots)
    Booking.new(court_number: court.number, playing_on: current_date.to_s(:uk), time_from: slots.current.from, time_to: slots.current.to)
  end

  def booking_by_slot(bookings, court, slots)
    bookings.by_slot(slots.current.from, court.number) || new_booking(court, slots)
  end

end