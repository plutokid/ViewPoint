class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :rating
      t.text    :comments

      t.timestamps
    end
    add_index :user_responses, :user_id
    add_index :user_responses, :location_id
    add_index :user_responses, [:user_id, :location_id], unique: true
  end
end
