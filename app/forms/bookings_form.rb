class BookingsForm
  include BasicForm

  set_model :booking, PERMITTED_ATTRIBUTES.booking.whitelist
  validate :verify_booking

  def submit(params, current_user)
    @booking = current_user.bookings.build(params)
    save
  end

  def save_objects
    run_transaction do
      booking.save
    end
  end

private

  def verify_booking
    check_for_errors booking
  end
end