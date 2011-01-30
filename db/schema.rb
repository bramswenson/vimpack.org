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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110125144436) do

  create_table "authors", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "homepage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scripts", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "script_id"
    t.string   "script_type"
    t.text     "summary"
    t.text     "description"
    t.text     "install_details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", :force => true do |t|
    t.integer  "script_id"
    t.integer  "latest_for_id"
    t.string   "filename"
    t.string   "script_version"
    t.date     "date"
    t.string   "vim_version"
    t.integer  "author_id"
    t.text     "release_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "versions", ["script_version", "script_id"], :name => "index_versions_on_script_version_and_script_id", :unique => true

  add_foreign_key "versions", "authors", :name => "versions_author_id_fk"
  add_foreign_key "versions", "scripts", :name => "versions_script_id_fk"

end
