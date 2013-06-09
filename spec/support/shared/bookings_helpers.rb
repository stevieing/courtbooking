module BookingsHelpers
  
  #this method will create some bookings during peak hours using the settings
  #the last booking will be a factory build which can be used to test validation
  #the last booking is the return value
  def create_peak_hours_bookings(courts, user, date, start_time, slot_time, max_bookings)
     time = Time.parse("#{(date + 7).beginning_of_week.to_s(:uk)} #{start_time}")
     court_number = courts.first.number
     booking = nil

     1.upto(max_bookings + 1) do |n|
       attributes = {court_number: court_number, playing_on: time.to_date.to_s(:uk), 
                      playing_from: time.to_s(:hrs_and_mins), playing_to: (time + slot_time.minutes).to_s(:hrs_and_mins) }
       booking = (n == max_bookings + 1) ? user.bookings.build(attributes) : user.bookings.create(attributes)
       time = time + 1.day + slot_time.minutes
       court_number = (court_number == courts.last.number ? courts.first.number : court_number + 1)
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