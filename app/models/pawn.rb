class Pawn < Piece

  def pawn_valid_move?(to_x, to_y)
    return false if pawn_move_horizontal?(to_x)
    if self.color == 'White'
      return false if to_y < starting_point_y
      if self.y_pos == 1
        return false if to_y > 3
      end
    else
      return false if to_y > starting_point_y
      if self.y_pos == 6
        return false if to_y < 4
      end
    end
    pawn_move_vertical?(to_y) || pawn_capture?(to_x, to_y)
  end

  private

  def pawn_move_horizontal?(to_x)
    right_or_left(to_x) != 0
  end

  def pawn_capture?(to_x, to_y)
    move_to!(to_x, to_y) && pawn_move_diagonal?(to_x, to_y)
  end

  def pawn_move_vertical?(to_y)
  	up_or_down(to_y) != 0 && to_y == starting_point_y + up_or_down(to_y)
  end

  def pawn_move_diagonal?(to_x, to_y)
    (starting_point_x - right_or_left(to_x)).abs == (starting_point_y - up_or_down(to_y)).abs
  end 

end