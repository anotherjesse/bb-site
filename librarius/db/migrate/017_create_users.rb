class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
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

  def self.down
    drop_table :users
  end
end
