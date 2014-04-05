# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# app settings

Setting.delete_all

NumberSetting.create(name: "days_bookings_can_be_made_in_advance", value: "21", description: "Number of days that courts can be booked in advance")
NumberSetting.create(name: "max_peak_hours_bookings_weekly", value: "3", description: "Maximum number of bookings that can be made during peak hours for the week")
NumberSetting.create(name: "max_peak_hours_bookings_daily", value: "1", description: "Maximum number of bookings that can be made during peak hours for the day")
NumberSetting.create(name: "slot_time", value: "40", description: "Slot time")
TimeSetting.create(name: "slot_first", value: "06:20", description: "First slot")
TimeSetting.create(name: "slot_last", value: "22:20", description: "Last slot")

Court.delete_all
CourtTime.delete_all
AllowedAction.delete_all
User.delete_all
Occurrence.delete_all
Permission.delete_all
Booking.delete_all
Activity.delete_all