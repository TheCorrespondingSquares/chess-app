class Removecolumnsfromgames < ActiveRecord::Migration[5.0]
  def change
  	remove_column :games, :private, :boolean
  	remove_column :games, :user_id, :integer
  	add_column :games, :white_player, :integer
  	add_column :games, :black_player, :integer
  	add_column :games, :result, :string
  end
end
