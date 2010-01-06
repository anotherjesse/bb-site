class CreateScrapes < ActiveRecord::Migration
  def self.up
    create_table :scrapes do |t|
      t.integer :library_id
      t.integer :book_id
      t.boolean :success
      t.boolean :expected
      t.timestamps
    end
  end

  def self.down
    drop_table :scrapes
  end
end
