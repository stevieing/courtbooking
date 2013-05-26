# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# standard and admin user
User.create(username: "Standard User", password: "password", email: "standarduser@example.com")
User.create(username: "Admin User", password: "password", email: "adminuser@example.com", admin: true)

# app settings
Setting.create(name: "days_that_can_be_booked_in_advance", value: "21", description: "Number of days that courts can be booked in advance")
Setting.create(name: "max_peak_hours_bookings", value: "3", description: "Maximum number of bookings that can be made during peak hours")
Setting.create(name: "peak_hours_start_time", value: "17:40", description: "Start of peak hours")
Setting.create(name: "peak_hours_finish_time", value: "19:40", description: "End of peak hours")

# court slots
TimeSlot.create(start_time: "06:20", finish_time: "22:00", slot_time: 40)

#courts
(1..4). each do |i|
  Court.create(number: i)
end


