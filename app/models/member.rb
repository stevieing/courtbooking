class Member < User

  include Permissions

  def all_bookings
    if allow?(:bookings, :edit)
      Booking.includes(:user, :court).ordered.load
    else
      bookings.includes(:court).ordered.load
    end
  end

end