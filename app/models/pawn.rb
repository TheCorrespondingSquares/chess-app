class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y)
      pawn_capture?(color, to_x, to_y)
    else
      pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y) && enpassant(to_x, to_y)
    end
  end

  def can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  def enpassant(to_x, to_y)
    @other_piece = opposite_piece?(other_piece).name == "Pawn"
    stay_on_x = @other_piece.x_pos
    if can_enpassant?(to_y)
      if is_white?
        to_x == stay_on_x && to_y == @other_piece.y_pos + 1
      else
        to_x == stay_on_x && to_y == @other_piece.y_pos - 1
      end
    end
  end
  
  
  private
  
  def can_enpassant?(to_y)
    !self.pawn_first_move?(to_y) && opponent_pawn_adjacent?
  end
  
  def opponent_pawn_adjacent?
    if @other_piece.name == "Pawn"
      (@other_piece.x_pos  == self.x_pos - 1 || @other_piece.x_pos == self.x_pos + 1) && @other_piece.y_pos == self.y_pos
    end
  end
  
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