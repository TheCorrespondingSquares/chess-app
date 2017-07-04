module Squares
  include Movements

  def all_squares
    squares = []
    n = 0

    while n < 8
      array = (0..7).map { |i| [nil, i] }
      squares << array
      n += 1
    end

    @all_squares = squares.flatten(1)
  end
  
  def occupied_squares
    pieces = Piece.where(game_id: self.game_id)
    @occupied_squares ||= pieces.pluck(:x_pos, :y_pos)
  end

  def is_on_square?(x, y)
    occupied_squares.include?([x, y])
  end

end