module BookingsHelpers

  def valid_booking_attributes
    FactoryGirl.attributes_for(:booking).merge(
      court_number: courts.first.number, playing_on: dates.current_date_to_s, 
      time_from: booking_slots.valid_slot.from, time_to: booking_slots.valid_slot.to)
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

  def create_subsequent_bookings(user, date, slots, no_of_bookings = 2)
    1.upto(no_of_bookings).each do |i|
      attrs = {court_number: courts.first.number, playing_on: (date+1).to_s(:uk), time_from: slots[i].from, time_to: slots[i].to}
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
  
  def valid_booking_details(booking)
    page.should have_content booking.court_number
    page.should have_content booking.playing_on_text
    page.should have_content booking.time_from
    page.should have_content booking.time_to
  end
  
end

World(BookingsHelpers)