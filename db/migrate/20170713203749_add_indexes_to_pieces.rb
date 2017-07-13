class AddIndexesToPieces < ActiveRecord::Migration[5.0]
  def change
    add_index :pieces, :color
    add_index :pieces, :captured
    add_index :pieces, [:x_pos, :y_pos]
  end
end
