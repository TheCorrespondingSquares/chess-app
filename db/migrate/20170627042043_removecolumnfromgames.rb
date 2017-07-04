class Removecolumnfromgames < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :white_player_turn
    add_column :games, :turn, :integer, default: 0
  end
end
