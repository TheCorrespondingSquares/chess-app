class AddGameName < ActiveRecord::Migration[5.0]
  def change

  	add_column :games, :name, :string
  	add_column :games, :public_game, :boolean
  end
end
