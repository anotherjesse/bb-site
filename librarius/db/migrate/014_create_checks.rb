class CreateChecks < ActiveRecord::Migration
  def self.up
    create_table :checks do |t|
      t.string :isbn
      t.datetime :last_tested_at
      t.datetime :last_passed_at
      t.integer :library_id
      t.boolean :passing
      t.boolean :expects
      t.timestamps
    end
  end

  def self.down
    drop_table :checks
  end
end
