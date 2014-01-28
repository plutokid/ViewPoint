class CreatePendingLocations < ActiveRecord::Migration
  def change
    create_table :pending_locations do |t|
      t.integer :user_id
      t.integer :location_id

      t.timestamps
    end
    add_index :pending_locations, :user_id
    add_index :pending_locations, :location_id
    add_index :pending_locations, [:user_id, :location_id], unique: true
  end
end
