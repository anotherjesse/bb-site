class DropScrapes < ActiveRecord::Migration
  def self.up
    drop_table :scrapes
  end

  def self.down
    puts "IRREVERSABLE MIGRATION!"
  end
end
