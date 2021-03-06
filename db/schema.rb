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

ActiveRecord::Schema.define(version: 20140128142342) do

  create_table "locations", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "gps_location"
    t.integer  "difficulty"
    t.text     "hints"
    t.text     "suggestions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "user_id"
  end

  add_index "locations", ["title", "description"], name: "index_locations_on_title_and_description", unique: true
  add_index "locations", ["user_id"], name: "index_locations_on_user_id"

  create_table "pending_locations", force: true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pending_locations", ["location_id"], name: "index_pending_locations_on_location_id"
  add_index "pending_locations", ["user_id", "location_id"], name: "index_pending_locations_on_user_id_and_location_id", unique: true
  add_index "pending_locations", ["user_id"], name: "index_pending_locations_on_user_id"

  create_table "user_responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.integer  "rating"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "user_responses", ["location_id"], name: "index_user_responses_on_location_id"
  add_index "user_responses", ["user_id", "location_id"], name: "index_user_responses_on_user_id_and_location_id", unique: true
  add_index "user_responses", ["user_id"], name: "index_user_responses_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.string   "gps_location"
  end

  add_index "users", ["remember_token"], name: "index_users_on_remember_token"
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
