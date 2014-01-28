class AddUniqueToLocation < ActiveRecord::Migration
  def change
    add_index  :locations, [:title, :description], unique: true
  end
end
