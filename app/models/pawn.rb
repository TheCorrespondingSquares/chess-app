class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if pawn_move_diagonal?(to_x, to_y)
      if is_on_square?(to_x, to_y)
        return true
      else
        return false
      end
    end
    pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y)
  end
  
  def self.can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  private
  
  def pawn_move_vertical?(to_x, to_y)
    pawn_move_forward?(to_y) && !is_on_square?(to_x, to_y) && pawn_first_move?(to_y)
  end

  def pawn_move_diagonal?(to_x, to_y)
    right_or_left(to_x).abs == up_or_down(to_y).abs
  end

  def pawn_move_forward?(to_y)
    if is_white?
      to_y > starting_point_y
    else
      to_y < starting_point_y
    end
  end

  def pawn_first_move?(to_y)
    if is_white?
      self.y_pos == 1 ? to_y < 4 : vertical_move_one_square?(to_y)
    else
      self.y_pos == 6 ? to_y > 3 : vertical_move_one_square?(to_y)
    end
  end
  
  def reached_opposite_border?(y_pos)
    white_reached_border?(y_pos) || black_reached_border?(y_pos)
  end
  
  def white_reached_border?(y_pos)
    y_pos == 7 && is_white?
  end
  
  def black_reached_border?(y_pos)
    y_pos == 0 && is_black?
  end
  
end