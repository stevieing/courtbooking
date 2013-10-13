module BookingsHelpers
  
  #this method will create some bookings during peak hours using the settings
  #the last booking will be a factory build which can be used to test validation
  #the last booking is the return value
  def create_peak_hours_bookings(court, user, date, max_bookings)
    slots = court.opening_times.find_by(:day => date.wday).slots
    start_of_peak_time = court.peak_times.find_by(:day => date.wday).from
    current_slot = slots.index(start_of_peak_time)
    booking = nil
    (1..max_bookings+1).each do |i|
      attributes = { court_number: court.number, playing_on: date.to_s(:uk), playing_from: slots[current_slot], playing_to: slots[current_slot+1]}
      booking = (i == max_bookings+1 ? user.bookings.build(attributes) : user.bookings.create(attributes))
      current_slot += 1
    end
    
    return booking
  end
   
   #create two bookings for each user on the same day
   #every other booking will have an opponent
   #each booking will have a subsequent slot time
   def create_valid_bookings(users, opponent, courts, date, slots)
     court_number, incr = courts.first.number, 0
     1.upto(users.length*2) do |i|
       user = users[incr]
       attributes = {court_number: court_number, playing_on: date.to_s(:uk), playing_from: slots[i], playing_to: slots[i+1]}
       if i % 2 == 0
         attributes[:opponent_id] = opponent.id
         incr += 1
       end
       court_number = (court_number == courts.last.number ? courts.first.number : court_number + 1)
       user.bookings.create(attributes)
     end
   end
end