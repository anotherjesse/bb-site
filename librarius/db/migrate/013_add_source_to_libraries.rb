class AddSourceToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :source, :string
  end

  def self.down
    remove_column :libraries, :source
  end
end
