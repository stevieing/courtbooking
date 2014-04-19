class Guest

  def all_bookings
    Booking.none
  end

  def valid?
    true
  end

  # TODO: remove this once permissions/policies have been removed
  def admin?
    false
  end

  def allowed_actions
    AllowedAction.none
  end

  def bookings
    Booking.none
  end
end