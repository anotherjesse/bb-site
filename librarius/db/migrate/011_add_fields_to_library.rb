class AddFieldsToLibrary < ActiveRecord::Migration
  def self.up
    add_column :libraries, :collection_info, :text
    add_column :libraries, :hours, :text
    add_column :libraries, :catalog_url, :text
    add_column :libraries, :special_features, :text
    add_column :libraries, :contacts, :text
    add_column :libraries, :historical_info, :text
  end

  def self.down
    remove_column :libraries, :collection_info
    remove_column :libraries, :hours
    remove_column :libraries, :catalog_url
    remove_column :libraries, :special_features
    remove_column :libraries, :contacts
    remove_column :libraries, :historical_info
  end
end
