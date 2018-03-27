class AddRoomTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :room_types do |t|
      t.integer :room_type, index: true
      t.references :hotel, foreign_key: true
      t.timestamps
    end
  end
end
