class AddReferenceToBlackPlayer < ActiveRecord::Migration[5.0]
  def change
  	add_reference :games, :black_player, references: :users, index: true
  	add_foreign_key :games, :users, column: :black_player_id
  end
end
