class Piece < ApplicationRecord
	include Movements
	include Squares
	include Obstructions

	belongs_to :game

	self.inheritance_column = :name

	scope :kings,		-> { where(name: 'King') }
	scope :queens, 	-> { where(name: 'Queen') }
	scope :bishops, -> { where(name: 'Bishop') }
	scope :knights, -> { where(name: 'Knight') }
	scope :rooks,		-> { where(name: 'Rook') }
	scope :pawns, 	-> { where(name: 'Pawn') }

	def self.names
		%w(King Queen Bishop Knight Rook Pawn)
	end

  def find_piece(x, y)
    Piece.find_by(x_pos: x, y_pos: y, game_id: game_id)
  end

  def friendly_piece?(other_piece)
    other_piece.color == self.color
  end

  def opposite_piece?(other_piece)
    !friendly_piece?(other_piece)
  end

  def capture_piece!(x, y, piece_to_capture)
    piece_to_capture.update_attributes(x_pos: nil, y_pos: nil, captured: true)
    self.update_attributes(x_pos: x, y_pos: y)
  end

  def move_to!(to_x, to_y)
    piece_on_square = find_piece(to_x, to_y)

    if piece_on_square && opposite_piece?(piece_on_square)
      capture_piece!(to_x, to_y, piece_on_square)
    elsif !piece_on_square
      self.update_attributes(x_pos: to_x, y_pos: to_y)
    end
  end

end
