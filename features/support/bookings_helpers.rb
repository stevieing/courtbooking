module BookingsHelpers

  def valid_booking_attributes
    FactoryGirl.attributes_for(:booking).merge(court_number: courts.first.number, playing_on: dates.current_date_to_s, playing_from: valid_playing_from, playing_to: valid_playing_to)
  end

  def build_valid_booking(opponent_id = nil)
    current_user.bookings.build(valid_booking_attributes.merge(opponent_id: opponent_id))
  end
  
  def create_valid_booking(user)
    create_booking(user, valid_booking_attributes)
  end

  def create_booking(user, attributes)
    user.bookings.create(attributes)
  end

  def valid_playing_from
    slot = slots.all.find_index { |slot| Time.parse(slot).to_sec > DateTime.now.to_sec }
    slot.nil? ? slots.all[length-1] : slots.all[slot]
  end

  def valid_playing_to
    slots.all[slots.all.find_index(valid_playing_from)+1]
  end
  
  def create_subsequent_bookings(user, date, slots, no_of_bookings = 2)
    1.upto(no_of_bookings).each do |i|
      attrs = {court_number: courts.first.number, playing_on: (date+1).to_s(:uk), playing_from: slots[i-1], playing_to: slots[i]}
      create_booking(user, FactoryGirl.attributes_for(:booking).merge(attrs))
    end
    Booking.all
  end
  
  def edit_bookings?(user, mine = true)
    Booking.all.each do |booking|
      if booking.user_id == user.id
        if mine
          page.should have_link(booking.players)
        else
          page.should_not have_link(booking.players)
        end
      else
        page.should have_content(booking.players)
      end
    end
  end

  #returns a booking which is a factory build
  def peak_hours_bookings_for_the_week(courts, current_user, slot_time)
    create_peak_hours_bookings_for_week(courts.first, current_user, dates.current_date+7, max_peak_hours_bookings_weekly, slots.all)
  end
  
  def peak_hours_bookings_for_the_day(courts, current_user, slot_time)
    create_peak_hours_bookings_for_day(courts.first, current_user, dates.current_date+7, max_peak_hours_bookings_daily, slots.all)
  end
  
  def valid_booking_details(booking)
    page.should have_content booking.court_number
    page.should have_content booking.playing_on_text
    page.should have_content booking.playing_from
    page.should have_content booking.playing_to
  end
  
end

World(BookingsHelpers)