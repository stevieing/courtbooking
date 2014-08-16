class BookingsController < ApplicationController

  before_filter :bookings, only: [:index]
  before_filter :store_location, only: [:index, :edit]

  def index
  end

  def new
    @bookings_form = BookingsForm.new(current_user, params)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @bookings_form = BookingsForm.new(current_user)
    process_booking :new, :create
  end

  def show
    @booking = current_resource
  end

  def edit
    @bookings_form = BookingsForm.new(current_user, current_resource)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @bookings_form = BookingsForm.new(current_user, current_resource)
    process_booking :edit, :update
  end

  def destroy
      @booking = current_resource
       if @booking.destroy
         BookingMailer.booking_cancellation(@booking).deliver
         notice = "Booking successfully deleted"
       else
         notice = "Unable to delete booking"
       end
       flash_keep notice
       #quick fix to cope with where destroy request comes from.
       if referrer_booking_path?
         redirect_to bookings_path
       else
         redirect_to courts_path(@booking.date_from)
       end
     end

protected

  def bookings
    @bookings ||= current_user.all_bookings
  end

private

  def process_booking(action, process)
    respond_to do |format|
      if @bookings_form.submit(params[:booking])
        BookingMailer.booking_confirmation(@bookings_form).deliver
        flash_keep "Booking successfully #{process.to_s}d."
        format.html { redirect_back_or_default(courts_path(@bookings_form.date_from)) }
        format.js { js_redirect_back_or_default(courts_path(@bookings_form.date_from))}
      else
        format.html { render action }
        format.js
      end
    end
  end

  def referrer_booking_path?
    Rails.application.routes.recognize_path(request.referrer)[:controller] == "bookings"
  end

  def current_resource
    @current_resource ||= Booking.find(params[:id]) if params[:id]
  end

  def flash_keep(message)
    flash[:notice] = message
    flash.keep(:notice)
  end

  def js_redirect(path)
    render js: %(window.location.href='#{path}')
  end

  helper_method :bookings

end
