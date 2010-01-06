class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :library_id
      t.string :title, :length => 255
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
