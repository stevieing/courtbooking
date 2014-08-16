class BookingsForm
  include BasicForm

  set_model :booking, PERMITTED_ATTRIBUTES.booking.whitelist
  validate :verify_booking

  delegate :user, :opponent, :user_id, :time_and_place, :players, to: :booking

  def initialize(current_user, booking_or_params = ActionController::Parameters.new)
    @booking = if booking_or_params.instance_of?(Booking)
      booking_or_params
    else
      current_user.bookings.build(current_user.permit_new!(:booking, booking_or_params))
    end
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