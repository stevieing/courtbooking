module BookingsHelpers
  
  def peak_hours_settings(settings = {})
    [:max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time].each do |setting|
      settings[setting].nil? ? create_setting(setting) : create_setting(setting, {value: settings[setting]})
    end
  end

  def valid_booking_attributes
    FactoryGirl.attributes_for(:booking).merge(playing_on: dates.current_date_to_s, playing_from: slots.playing_from, playing_to: slots.playing_to)
  end

  def build_valid_booking
    current_user.bookings.build(valid_booking_attributes)
  end
  
  def create_valid_booking(user)
    create_booking(user, valid_booking_attributes)
  end

  def create_booking(user, attributes)
    user.bookings.create(attributes)
  end
  
  def create_subsequent_bookings(user, date, slots, no_of_bookings = 2)
    1.upto(no_of_bookings).each do |i|
      attrs = {playing_on: (date+1).to_s(:uk), playing_from: slots[i-1], playing_to: slots[i]}
      create_booking(user, FactoryGirl.attributes_for(:booking).merge(attrs))
    end
    Booking.all
  end
  
  def edit_my_bookings?(user)
    Booking.all.each do |booking|
      if booking.user_id == user.id
        page.should have_link(booking.players) 
      else
        page.should have_content(booking.players)
      end
    end
  end
  
  def edit_others_bookings?(user)
    Booking.all.each do |booking|
       if booking.user_id == user.id
         page.should_not have_link(booking.players)
       else
         page.should have_content(booking.players)
       end
     end
  end

  #returns a booking which is a factory build
  def peak_hours_bookings(courts, current_user, slot_time)
    create_peak_hours_bookings(courts, current_user, dates.current_date+7, peak_hours_start_time, slot_time, max_peak_hours_bookings)
  end
end

World(BookingsHelpers)