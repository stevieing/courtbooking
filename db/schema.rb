# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140808062153) do

  create_table "activities", force: true do |t|
    t.string   "description"
    t.date     "date_from"
    t.date     "date_to"
    t.string   "time_from"
    t.string   "time_to"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "allowed_actions", force: true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.boolean  "user_specific", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",         default: false
  end

  create_table "bookings", force: true do |t|
    t.integer  "user_id"
    t.integer  "court_id"
    t.integer  "opponent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_from"
    t.string   "time_from"
    t.string   "time_to"
    t.string   "opponent_name"
  end

  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id"

  create_table "court_times", force: true do |t|
    t.integer  "court_id"
    t.integer  "day"
    t.string   "time_from"
    t.string   "time_to"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "court_times", ["court_id"], name: "index_court_times_on_court_id"

  create_table "courts", force: true do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "occurrences", force: true do |t|
    t.integer  "activity_id"
    t.integer  "court_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "occurrences", ["activity_id"], name: "index_occurrences_on_activity_id"
  add_index "occurrences", ["court_id"], name: "index_occurrences_on_court_id"

  create_table "permissions", force: true do |t|
    t.integer  "allowed_action_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["allowed_action_id"], name: "index_permissions_on_allowed_action_id"

  create_table "settings", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.boolean  "mail_me",                default: true
    t.string   "full_name"
    t.string   "type"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
