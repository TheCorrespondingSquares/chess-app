module Squares
  include Movements
  
  def occupied_squares
    pieces = Piece.where(game_id: self.game_id)
    @occupied_squares ||= pieces.all.pluck(:x_pos, :y_pos)
  end

  def is_on_square?(x, y)
    occupied_squares.include?([x, y])
  end  

end