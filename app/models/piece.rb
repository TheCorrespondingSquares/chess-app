class Piece < ApplicationRecord
	belongs_to :game

	self.inheritance_column = :name

	scope :kings,	-> { where(name: 'King') }
	scope :queens, 	-> { where(name: 'Queen') }
	scope :bishops, -> { where(name: 'Bishop') }
	scope :knights, -> { where(name: 'Knight') }
	scope :rooks,	-> { where(name: 'Rook') }
	scope :pawns, 	-> { where(name: 'Pawn') }

	def self.names
		%w(King Queen Bishop Knight Rook Pawn)
	end

  include Movements
  include Squares
  include Obstructions

  def move_to!(destination_x, destination_y)
    if !self.is_obstructed?(destination_x, destination_y)

      if is_on_square?(destination_x, destination_y)

      end

      self.update_attributes(x_pos: destination_x, y_pos: destination_y)
    end
  end  

end
