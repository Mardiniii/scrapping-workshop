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

ActiveRecord::Schema.define(version: 20150313221417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string   "market"
    t.string   "property_type"
    t.datetime "date"
    t.integer  "stratum"
    t.string   "city"
    t.string   "neighborhood"
    t.integer  "built_area"
    t.integer  "rooms_number"
    t.string   "property_code"
    t.integer  "rotation_days"
    t.string   "url"
    t.string   "source"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "published"
    t.integer  "sale_value",          limit: 8
    t.integer  "meter_squared_value", limit: 8
  end

  create_table "scan_events", force: :cascade do |t|
    t.integer  "property_id"
    t.integer  "event_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "old_price",   limit: 8
    t.integer  "new_price",   limit: 8
  end

  add_index "scan_events", ["property_id"], name: "index_scan_events_on_property_id", using: :btree

  add_foreign_key "scan_events", "properties"
end
