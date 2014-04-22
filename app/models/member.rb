class Member < User

  include Permissions

  # TODO: remove this once permissions/policies have been removed
  def admin?
    false
  end

  def all_bookings
    if current_permissions.allow_all?(:bookings, :edit)
      Booking.includes(:user, :court).ordered.load
    else
      bookings.includes(:court).ordered.load
    end
  end

end