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

ActiveRecord::Schema.define(version: 20200531092119) do

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "event_name", default: "", null: false
    t.string "chouseisan_note"
    t.string "chouseisan_url"
    t.boolean "chouseisan_check", default: true, null: false
    t.string "place", default: ""
    t.integer "indication_price"
    t.date "deadline"
    t.datetime "reserved_at"
    t.string "reserved_by"
    t.integer "reserved_number_of_members"
    t.string "reference"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "station", default: ""
    t.integer "event_status", default: 0
    t.string "initial_invitation_statement"
    t.string "schedule_information_statement"
    t.string "final_invitation_statement"
    t.integer "total_payment", default: 0
    t.integer "fee_unit", default: 100
    t.float "rate_of_fee_slope", limit: 24, default: 1.5
    t.integer "calculation_method_type", default: 0
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "member_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "attendance_status", default: 0
    t.integer "payment_status", default: 1
    t.integer "fee"
    t.bigint "member_id"
    t.bigint "schedule_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_schedules_on_member_id"
    t.index ["schedule_id"], name: "index_member_schedules_on_schedule_id"
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "member_name", null: false
    t.string "email"
    t.string "line"
    t.string "comment"
    t.integer "column_number"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remark"
    t.boolean "attended", default: false, null: false
    t.index ["event_id"], name: "index_members_on_event_id"
  end

  create_table "schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "held_at", null: false
    t.boolean "decided"
    t.integer "attendance_numbers", default: 0, null: false
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_schedules_on_event_id"
  end

  create_table "shops", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "shop_name"
    t.string "shop_url"
    t.string "shop_station"
    t.string "shop_telephonenumber"
    t.string "shop_address"
    t.string "course"
    t.string "remark"
    t.boolean "decided"
    t.integer "price"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_shops_on_event_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", default: "Guest", null: false
    t.boolean "admin", default: false, null: false
    t.string "web_search_url", default: "https://www.google.co.jp/", null: false
    t.string "train_search_url", default: "https://transit.yahoo.co.jp/", null: false
    t.integer "days_before", default: 1, null: false
    t.string "provider"
    t.string "uid"
    t.string "station", default: ""
    t.string "map_url", default: "https://www.google.co.jp/maps/", null: false
    t.integer "number_of_members_per_one_page", default: 10
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "events", "users"
  add_foreign_key "member_schedules", "members"
  add_foreign_key "member_schedules", "schedules"
  add_foreign_key "members", "events"
  add_foreign_key "schedules", "events"
  add_foreign_key "shops", "events"
end
