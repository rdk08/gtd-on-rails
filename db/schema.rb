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

ActiveRecord::Schema.define(version: 20151028181941) do

  create_table "goals", force: :cascade do |t|
    t.text     "description"
    t.boolean  "achieved"
    t.datetime "achieved_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "archived"
  end

  create_table "project_states", force: :cascade do |t|
    t.string   "symbol"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "display_name"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "goal_description"
    t.date     "soft_deadline"
    t.date     "hard_deadline"
    t.integer  "project_state_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "completed_at"
    t.string   "name"
  end

  add_index "projects", ["project_state_id"], name: "index_projects_on_project_state_id"

  create_table "task_states", force: :cascade do |t|
    t.string   "symbol"
    t.string   "display_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "description"
    t.integer  "task_state_id"
    t.boolean  "have_to"
    t.date     "date"
    t.string   "date_hour"
    t.boolean  "date_due"
    t.datetime "completed_at"
    t.integer  "project_id"
    t.string   "additional_info"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "pomodorro_sessions"
    t.integer  "list_id"
  end

  add_index "tasks", ["list_id"], name: "index_tasks_on_list_id", unique: true
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"
  add_index "tasks", ["task_state_id"], name: "index_tasks_on_task_state_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
