# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 17) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.string   "image_url"
    t.string   "isbn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checks", :force => true do |t|
    t.string   "isbn"
    t.datetime "last_tested_at"
    t.datetime "last_passed_at"
    t.integer  "library_id"
    t.boolean  "passing"
    t.boolean  "expects"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "library_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libraries", :force => true do |t|
    t.string  "name"
    t.string  "location"
    t.text    "bookmarklet"
    t.string  "opac"
    t.string  "full_address"
    t.string  "country_code"
    t.string  "state"
    t.string  "city"
    t.float   "lat"
    t.float   "lng"
    t.string  "isbn_link"
    t.text    "collection_info"
    t.text    "hours"
    t.text    "catalog_url"
    t.text    "special_features"
    t.text    "contacts"
    t.text    "historical_info"
    t.string  "source"
    t.boolean "match_isbn"
    t.string  "match_positive"
    t.string  "match_negative"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash",        :limit => 40
    t.string   "email",                :limit => 100
    t.string   "website",              :limit => 100
    t.string   "display_name",         :limit => 80
    t.string   "recover_password",     :limit => 128
    t.datetime "last_login_at"
    t.boolean  "admin"
    t.datetime "last_seen_at"
    t.string   "login_key"
    t.datetime "login_key_expires_at"
    t.boolean  "activated",                           :default => false
    t.integer  "comments_count",                      :default => 0
  end

end
