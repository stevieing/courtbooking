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
NumberSetting.create(name: "days_bookings_can_be_made_in_advance", value: "21", description: "Number of days that courts can be booked in advance")
NumberSetting.create(name: "max_peak_hours_bookings", value: "3", description: "Maximum number of bookings that can be made during peak hours")
NumberSetting.create(name: "slot_time", value: "40", description: "Slot time")
TimeSetting.create(name: "start_time", value: "06:20", description: "Court opening time")
TimeSetting.create(name: "finish_time", value: "22:00", description: "Court closing time")

#courts
(1..4). each do |i|
  Court.create(number: i)
end

Setting.all.each do |instance|
  instance.add_config
end

Slots.create

Court.all.each do |c|
  (0..6).each do |day|
    c.opening_times.build(day: day, from: "06:20", to: "08:20").save
    c.opening_times.build(day: day, from: "17:40", to: "22:00").save
    c.peak_times.build(day: day, from: "17:40", to: "20:20").save if day < 5
  end
end

AllowedAction.create(name: "View all bookings",controller: :bookings,action: [:index])
AllowedAction.create(name: "Create a new booking",controller: :bookings,action: [:new, :create])
AllowedAction.create(name: "View a booking",controller: :bookings,action: [:show])
AllowedAction.create(name: "Delete a booking",controller: :bookings,action: [:destroy], user_specific: true)
AllowedAction.create(name: "Edit a booking",controller: :bookings,action: [:edit, :update],user_specific: true)

user = User.find_by(username: "Standard User")

AllowedAction.all.each do |permission|
  user.permissions.create(allowed_action_id: permission.id)
end

