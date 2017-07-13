class Piece < ApplicationRecord
  include ActiveModel::Dirty
  include Movements
  include Squares
  include Obstructions

  belongs_to :game

  self.inheritance_column = :name

  scope :kings,   -> { where(name: 'King') }
  scope :queens,  -> { where(name: 'Queen') }
  scope :bishops, -> { where(name: 'Bishop') }
  scope :knights, -> { where(name: 'Knight') }
  scope :rooks,   -> { where(name: 'Rook') }
  scope :pawns,   -> { where(name: 'Pawn') }

  def self.names
    %w(King Queen Bishop Knight Rook Pawn)
  end

  def piece_exists?(x, y)
    game.pieces.find_by(x_pos: x, y_pos: y)
  end

  def friendly_piece?(other_piece)
    other_piece.color == self.color
  end

  def opposite_piece?(other_piece)
    !friendly_piece?(other_piece)
  end

  def friendly_piece_on_square?(x, y)
    if piece_exists?(x, y)
      piece_exists?(x, y).color == self.color
    else
      false
    end
  end

  def capture_piece!(x, y, piece_to_capture)
    piece_to_capture.update_attributes(x_pos: nil, y_pos: nil, captured: true)
    self.update_attributes(x_pos: x, y_pos: y)
  end

  def move_to!(to_x, to_y)
    piece_on_square = piece_exists?(to_x, to_y)

    if piece_on_square && opposite_piece?(piece_on_square)
      capture_piece!(to_x, to_y, piece_on_square)
    elsif !piece_on_square
      self.update_attributes(x_pos: to_x, y_pos: to_y)
    end
  end

  def all_valid_moves
    valid_moves = []

    all_squares.each do |square|
      x = square[0]
      y = square[1]

      valid_moves << [x, y] if self.valid_move?(x, y)
    end

    return valid_moves
  end
  
  def is_white?
    self.color == "White"
  end
  
  def is_black?
    self.color == "Black"
  end
end
