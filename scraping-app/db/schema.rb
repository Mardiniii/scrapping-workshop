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

ActiveRecord::Schema.define(version: 20150220215230) do

  create_table "properties", force: :cascade do |t|
    t.string   "market"
    t.string   "property_type"
    t.datetime "date"
    t.integer  "stratum"
    t.string   "city"
    t.string   "neighborhood"
    t.integer  "built_area"
    t.integer  "sale_value",          limit: 8
    t.integer  "meter_squared_value"
    t.integer  "rooms_number"
    t.string   "property_code"
    t.integer  "rotation_days"
    t.string   "url"
    t.string   "source"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "published"
  end

  create_table "scan_events", force: :cascade do |t|
    t.integer  "property_id"
    t.integer  "event_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "scan_events", ["property_id"], name: "index_scan_events_on_property_id"

end
