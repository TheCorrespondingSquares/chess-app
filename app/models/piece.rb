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

  def move_to!(x, y)
    if !self.is_obstructed?(x, y)

      if is_on_square?(x, y)
        capture_piece!(x, y)
      end

      self.update_attributes(x_pos: x, y_pos: y)
    end
  end

  def capture_piece!(x, y)
    captured_piece = Piece.where(x_pos: x, y_pos: y, game_id: self.game_id)
    captured_piece.update_attributes(x_pos: nil, y_pos: nil)
  end

end
