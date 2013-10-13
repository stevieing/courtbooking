class BookingsController < ApplicationController
  
  def new
    @booking = Booking.new
    set_params :playing_on,:court_number,:playing_from,:playing_to
    @header = "New Booking"
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @booking = current_user.bookings.build(params[:booking])
    respond_to do |format|
      if @booking.save
        BookingMailer.booking_confirmation(@booking).deliver
        flash_keep 'Booking successfully created.'
        format.html { redirect_to courts_path(@booking.playing_on) }
        format.js { js_redirect(courts_path(@booking.playing_on))}
      else
        format.html { render :new }
        format.js
      end
    end
  end
  
  def show
    @booking = current_resource
  end
  
  def edit
    @header = "Edit booking"
    @booking = current_resource
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def update
    @booking = current_resource
    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        BookingMailer.booking_confirmation(@booking).deliver
        flash_keep 'Booking successfully updated.'
        format.html { redirect_to root_path }
        format.js { js_redirect(courts_path(@booking.playing_on))}
      else
        format.html { render :edit }
        format.js
      end
    end
  end
  
  def destroy
    @booking = current_resource
    if @booking.destroy
      BookingMailer.booking_cancellation(@booking).deliver
      notice = "Booking successfully deleted"
    else
      notice = "Unable to delete booking"
    end
    redirect_to courts_path(@booking.playing_on), notice: notice
  end

private
  
  def current_resource
    @current_resource ||= Booking.find(params[:id]) if params[:id]
  end
  
  def set_params(*attributes)
    attributes.each do |attribute|
      @booking.send("#{attribute}=", params[attribute]) unless params[attribute].nil?
    end
  end
  
  def flash_keep(message)
    flash[:notice] = message
    flash.keep(:notice)
  end
  
  def js_redirect(path)
    render js: %(window.location.href='#{path}')
  end

end
