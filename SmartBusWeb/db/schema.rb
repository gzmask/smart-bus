# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090720220549) do

  create_table "web_buses", :force => true do |t|
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_locations", :force => true do |t|
    t.integer  "web_bus_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "is_current"
    t.boolean  "is_end"
    t.boolean  "is_pickup"
    t.boolean  "is_dropdown"
    t.integer  "web_passenger_id"
    t.integer  "order_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_locks", :force => true do |t|
    t.string   "resource"
    t.boolean  "in_use"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "web_passengers", :force => true do |t|
    t.string   "password"
    t.integer  "web_bus_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
