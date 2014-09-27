class BookingForm
  include BasicForm

  set_model :booking, PERMITTED_ATTRIBUTES.booking.whitelist
  validate :verify_booking

  delegate :user, :opponent, :user_id, :time_and_place, :players, to: :booking

  def initialize(current_user, booking_or_params = ActionController::Parameters.new)
    @booking = if booking_or_params.instance_of?(Booking)
      booking_or_params
    else
      current_user.bookings.build(current_user.permit_new!(:booking, process_parameters(booking_or_params)))
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

  def process_parameters(params)
    return params if params.empty?
    slot = Settings.slots.find_by_id(params[:court_slot_id].to_i)
    params.except(:court_slot_id).merge(time_from: slot.from, time_to: slot.to, court_id: slot.court_id)
  end
end