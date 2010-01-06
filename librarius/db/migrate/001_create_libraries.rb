class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string   "name"
      t.string   "location"
      t.text     "bookmarklet"
      t.string   "opac"
      t.string   "full_address"
      t.string   "country_code"
      t.string   "state"
      t.string   "city"
      t.float    "lat"
      t.float    "lng"
      
    end
  end

  def self.down
    drop_table :libraries
  end
end
