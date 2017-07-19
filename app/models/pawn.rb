class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y)
      pawn_capture?(color, to_x, to_y)
    else
      pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y) && enpassant
    end
  end

  def can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  #logic to perform enpassant
  def enpassant
    if is_white?
      self.update_attributes(x_pos: @opponent_pawn.x_pos, y_pos: @opponent_pawn.y_pos + 1)
    else
      self.update_attributes(x_pos: @opponent_pawn.x_pos, y_pos: @opponent_pawn.y_pos - 1)
    end
  end
  
  #boolean for enpassant
  def can_enpassant?
    opponent_pawn_adjacent? && moved_two_squares_first_turn?
  end
  
  
  
  #determines if piece has moved two squares to be captured
  def moved_two_squares_first_turn?
    @opponent_pawn.turn == 1 && (@opponent_pawn.y_pos == @opponent_pawn.starting_point_y + 2 || @opponent_pawn.y_pos == @opponent_pawn.starting_point_y - 2)
  end
      
  #determines if opponent pawn is in position for enpassant
  def opponent_pawn_adjacent?
    @opponent_pawn = game.pieces.find_by(name: "Pawn") && !self.color
    if @opponent_pawn.y_pos == self.y_pos && (@opponent_pawn.x_pos == self.x_pos - 1 || @opponent_pawn.x_pos == self.x_pos + 1)
      true
    else
      false
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