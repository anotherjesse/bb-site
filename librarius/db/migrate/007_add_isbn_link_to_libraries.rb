class AddIsbnLinkToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :isbn_link, :string
  end

  def self.down
    remove_column :libraries, :isbn_link
  end
end
