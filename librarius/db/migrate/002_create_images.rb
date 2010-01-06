class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :library_id, :integer
    end
  end

  def self.down
    drop_table :images
  end
end
