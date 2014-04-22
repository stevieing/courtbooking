class Admin < User

  include Permissions

  def admin?
    true
  end

  def all_bookings
    Booking.includes(:user, :court).ordered.load
  end
end