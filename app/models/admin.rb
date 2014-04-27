class Admin < User

  include Permissions

  def all_bookings
    Booking.includes(:user, :court).ordered.load
  end
end