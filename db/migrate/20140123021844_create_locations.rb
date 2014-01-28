class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :title
      t.text :description
      t.string :gps_location
      t.integer :difficulty
      t.text :hints
      t.text :suggestions

      t.timestamps
    end
  end
end
