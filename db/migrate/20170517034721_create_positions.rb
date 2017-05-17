class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.string :coordinates
      t.integer :piece_id
      t.timestamps
    end
    add_index :positions, :coordinates
    add_index :positions, :piece_id
  end
end
