module BookingsHelpers
  
  #this method will create some bookings during peak hours using the settings
  #the last booking will be a factory build which can be used to test validation
  #the last booking is the return value
  def create_peak_hours_bookings_for_week(court, user, date, max_bookings, slots)
    create_peak_hours_bookings(court, user, date, max_bookings, slots, :date)
  end
  
  def create_peak_hours_bookings(court, user, date, max_bookings, slots, by)
    current_date = date.beginning_of_week
    increment = {date: 0, slot: 0}
    booking = nil
    (1..max_bookings+1).each do |i|
      slot_index = get_slots(court, current_date + increment[:date], slots)
      attributes = set_attributes(court, current_date + increment[:date], slots, slot_index + increment[:slot])
      booking = (i == max_bookings+1 ? user.bookings.build(attributes) : user.bookings.create(attributes))
      increment[by] += 1
    end
    return booking
  end
  
  def create_peak_hours_bookings_for_day(court, user, date, max_bookings, slots)
    create_peak_hours_bookings(court, user, date, max_bookings, slots, :slot)
  end

  def get_slots(court, date, slots)
    slots.find_index{|slot| slot.from == court.peak_times.find_by(:day => date.wday).time_from }
  end
  
  def set_attributes(court, date, slots, index)
    { court_number: court.number, playing_on: date.to_s(:uk), time_from: slots[index].from, time_to: slots[index].to}
  end
   
   #create two bookings for each user on the same day
   #every other booking will have an opponent
   #each booking will have a subsequent slot time
   def create_valid_bookings(users, opponent, courts, date, slots)
     court_number, incr = courts.first.number, 0
     1.upto(users.length*2) do |i|
       user = users[incr]
       attributes = {court_number: court_number, playing_on: date.to_s(:uk), time_from: slots[i].from, time_to: slots[i].to}
       if i % 2 == 0
         attributes[:opponent_id] = opponent.id
         incr += 1
       end
       court_number = (court_number == courts.last.number ? courts.first.number : court_number + 1)
       user.bookings.create(attributes)
     end
   end
   
   
end