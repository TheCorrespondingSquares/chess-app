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

    capture_piece!(destination_x, destination_y)


    self.update_attributes(x_pos: destination_x, y_pos: destination_y)
  end

  def find_piece(x, y, game_id)
    Piece.find_by(x_pos: x, y_pos: y, game_id: game_id)
  end

  def capture_piece!(x, y)
    piece_to_capture = find_piece(x, y, self.game_id)
    piece_to_capture.update_attributes(x_pos: nil, y_pos: nil) if piece_to_capture
  end

end
