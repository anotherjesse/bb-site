class DropImages < ActiveRecord::Migration
  def self.up
    drop_table :images
  end

  def self.down
    puts "IRREVERSABLE MIGRATION!"
  end
end
