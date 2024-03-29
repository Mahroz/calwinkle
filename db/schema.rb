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

ActiveRecord::Schema.define(version: 2019_03_11_105803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "event_calendars", force: :cascade do |t|
    t.integer "user_id"
    t.text "calendar_html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_reports", force: :cascade do |t|
    t.bigint "event_id"
    t.integer "viewer_count", default: 0
    t.integer "subscriber_count", default: 0
    t.index ["event_id"], name: "index_event_reports_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "address"
    t.time "start_time"
    t.time "end_time"
    t.date "start_date"
    t.date "end_date"
    t.string "main_picture"
    t.string "event_url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "occurance_rule"
    t.integer "occurance_type"
    t.boolean "is_cancel", default: false
    t.string "time_zone"
    t.integer "custom_occurance_every_duration"
    t.string "custom_occurance_every_duration_type"
    t.text "custom_occurance_weekly_selected_days", default: [], array: true
    t.date "custom_occurance_monthly_at"
    t.date "custom_occurance_repeat_ends_at"
    t.string "custom_occurance_ends_on_type"
    t.integer "custom_occurance_ends_after_duration"
    t.string "custom_occurance_monthly_sub_type"
    t.string "organizer_name"
    t.string "organizer_phone"
    t.string "organizer_email"
    t.string "organizer_website"
    t.string "organizer_picture"
    t.integer "custom_occurance_every_duration"
    t.string "custom_occurance_every_duration_type"
    t.text "custom_occurance_weekly_selected_days", default: [], array: true
    t.date "custom_occurance_monthly_at"
    t.date "custom_occurance_repeat_ends_at"
    t.string "custom_occurance_ends_on_type"
    t.integer "custom_occurance_ends_after_duration"
    t.string "custom_occurance_monthly_sub_type"
    t.index ["event_url"], name: "index_events_on_event_url", unique: true
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
