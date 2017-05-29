class AddReferenceToWhitePlayer < ActiveRecord::Migration[5.0]
  def change
  	add_reference :games, :white_player, references: :users, index: true
  	add_foreign_key :games, :users, column: :white_player_id
  end
end
