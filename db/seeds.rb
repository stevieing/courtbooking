# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: "Standard User", password: "password", email: "standarduser@example.com")
User.create(username: "Admin User", password: "password", email: "adminuser@example.com", admin: true)
Setting.create(name: "days_that_can_be_booked_in_advance", value: "21", description: "Number of days that courts can be booked in advance")
TimeSlot.create(start_time: "06:40", finish_time: "22:00", slot_time: 40)

(1..4). each do |i|
  Court.create(number: i)
end


