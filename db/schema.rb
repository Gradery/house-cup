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

ActiveRecord::Schema.define(version: 20150903211830) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "activities", force: true do |t|
    t.text     "name"
    t.integer  "points"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "activities", ["deleted_at"], name: "index_activities_on_deleted_at"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_id"
    t.datetime "deleted_at"
  end

  add_index "admin_users", ["deleted_at"], name: "index_admin_users_on_deleted_at"
  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "houses", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "points"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "deleted_at"
  end

  add_index "houses", ["deleted_at"], name: "index_houses_on_deleted_at"

  create_table "members", force: true do |t|
    t.integer  "school_id"
    t.integer  "house_id"
    t.string   "badge_id"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "members", ["deleted_at"], name: "index_members_on_deleted_at"

  create_table "point_assignments", force: true do |t|
    t.integer  "staff_id"
    t.integer  "house_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "note"
    t.integer  "member_id"
  end

  add_index "point_assignments", ["deleted_at"], name: "index_point_assignments_on_deleted_at"

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.text     "about"
    t.datetime "deleted_at"
  end

  add_index "schools", ["deleted_at"], name: "index_schools_on_deleted_at"

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "settings", ["deleted_at"], name: "index_settings_on_deleted_at"

  create_table "staffs", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "school_id"
    t.integer  "house_id"
    t.string   "grade"
    t.datetime "deleted_at"
  end

  add_index "staffs", ["deleted_at"], name: "index_staffs_on_deleted_at"
  add_index "staffs", ["email"], name: "index_staffs_on_email", unique: true
  add_index "staffs", ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true

end
