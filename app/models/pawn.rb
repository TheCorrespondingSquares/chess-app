class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y) #enpassant should go here
      pawn_capture?(color, to_x, to_y)
    else
      pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y) 
    end
  end

  def can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  #logic to perform enpassant
  def enpassant(to_x, to_y)
    if can_enpassant? && diagonal_move_one_square?(to_x, to_y)
      if is_white?
        to_x == opponent_pawn?.x_pos  && to_y == opponent_pawn?.y_pos + 1
      else
        to_x == opponent_pawn?.x_pos && to_y == opponent_pawn?.y_pos - 1

      end
    end
  end
  
  #boolean for enpassant
  def can_enpassant?
    two_square_first_move? && opponent_pawn_adjacent?
  end
  
  
  
  #determines if piece has moved two squares to be captured
  def two_square_first_move?
    if is_white?
      y_pos == starting_point_y + 2
    else
      y_pos == starting_point_y - 2
    end
  end
      
  #determines if opponent is in position for enpassant
  def opponent_pawn_adjacent?
    (opponent_pawn.x_pos == self.x_pos - 1 || opponent_pawn.x_pos == self.x_pos + 1) && opponent_pawn.y_pos == self.y_pos
  end
  
  #determines opponent pawn
  def opponent_pawn(other_piece)
    self.color != other_piece.color && other_piece.name == "Pawn"
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