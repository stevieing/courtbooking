module BookingsHelpers
  
  def peak_hours_settings(settings = {})
    [:max_peak_hours_bookings, :peak_hours_start_time, :peak_hours_finish_time].each do |setting|
      settings[setting].nil? ? create_setting(setting) : create_setting(setting, {value: settings[setting]})
    end
  end
  
  def set_date(mod)
    "#{(Date.today+mod).to_s(:uk)}"
  end
  
  def valid_playing_on
    set_date(1)
  end
  
  def date_in_the_past(days)
    set_date(-days)
  end
  
  def date_in_the_future(days)
    set_date(days)
  end
  
  def valid_playing_from
    set_playing_from(20)
  end
  
  def set_playing_from(i)
    time_slots.slots[i]
  end
  
  def valid_playing_to
    time_slots.slots[21]
  end
  
  def days_bookings_can_be_made_in_advance
    @days_bookings_can_be_made_in_advance ||= Rails.configuration.days_bookings_can_be_made_in_advance
  end
  
  def peak_hours_start_time
    @peak_hours_start_time ||= Rails.configuration.peak_hours_start_time
  end
  
  def peak_hours_finish_time
    @peak_hours_finish_time ||= Rails.configuration.peak_hours_finish_time
  end
  
  def max_peak_hours_bookings
    @max_peak_hours_bookings ||= Rails.configuration.max_peak_hours_bookings
  end
  
  def create_current_booking(booking)
    @current_booking = booking
  end
  
  def current_booking
    @current_booking ||= create(:booking)
  end
  
  def create_current_bookings(bookings)
    @current_bookings = bookings
  end
  
  def current_bookings
    @current_bookings
  end
  
  def create_booking(attributes)
    create(:booking, attributes)
  end
  
  def create_valid_booking(current_user, court_number = courts.first.number, playing_on = valid_playing_on, playing_from = valid_playing_from)
    create_booking({user_id: current_user.id, court_number: court_number, playing_on: playing_on, playing_from: playing_from})
  end
  
  def create_subsequent_bookings(current_user, date, slots, no_of_bookings = 2, court_number = courts.first.number)
    1.upto(no_of_bookings).each do |i|
      create_booking({user_id: current_user.id, court_number: court_number, playing_on: (date+1).to_s(:uk), playing_from: slots[i-1]})
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
    create_peak_hours_bookings(courts, current_user, (Date.today+7), peak_hours_start_time, slot_time, max_peak_hours_bookings)
  end
end

World(BookingsHelpers)