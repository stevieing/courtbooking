class Guest

  include Permissions

  def initialize
    add_current_permissions
  end

  def all_bookings
    Booking.none
  end

  def valid?
    true
  end

end