class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y)
      pawn_capture?(color, to_x, to_y)
    else
      pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y)
    end
  end


  private

  def pawn_move_vertical?(to_x, to_y)
    pawn_move_forward?(to_y) && !is_on_square?(to_x, to_y) && pawn_first_move?(to_y)
  end

  def pawn_move_diagonal?(to_x, to_y)
    right_or_left(to_x).abs == up_or_down(to_y).abs
  end

  def opposite_is_on_square?(color, to_x, to_y)
    game.pieces.where(x_pos: to_x, y_pos: to_y, color: !color)
  end

  def pawn_capture?(color, to_x, to_y)
    opposite_is_on_square?(color, to_x, to_y) && diagonal_move_one_square?(to_x, to_y)
  end

  def pawn_move_forward?(to_y)
    if self.color == "White"
      to_y > starting_point_y
    else
      to_y < starting_point_y
    end
  end

  def pawn_first_move?(to_y)
    if self.color == 'White'
      self.y_pos == 1 ? to_y < 4 : vertical_move_one_square?(to_y)
    else
      self.y_pos == 6 ? to_y > 3 : vertical_move_one_square?(to_y)
    end
  end
end
