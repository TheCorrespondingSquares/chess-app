class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.string :name
      t.string :color
      t.integer :x_pos
      t.integer :y_pos
      t.integer :game_id
      t.boolean :captured, default: false
      t.timestamps
    end
    add_index :pieces, :game_id
  end
end
