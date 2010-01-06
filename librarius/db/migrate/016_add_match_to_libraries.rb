class AddMatchToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :match_isbn, :boolean
    add_column :libraries, :match_positive, :string
    add_column :libraries, :match_negative, :string
  end

  def self.down
    remove_column :libraries, :match_isbn
    remove_column :libraries, :match_positive
    remove_column :libraries, :match_negative
  end
end
