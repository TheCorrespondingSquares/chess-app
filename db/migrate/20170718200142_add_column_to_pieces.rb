class AddColumnToPieces < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :turn, :integer, :default => 0
  end
end
