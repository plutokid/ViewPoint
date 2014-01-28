class AddGpsLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gps_location, :string
  end
end
