class AddRoomDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :room_details do |t|
      t.references :room_type, foreign_key: true
      t.integer :availability
      t.integer :price
      t.datetime :date
      t.timestamps
    end
  end
end
