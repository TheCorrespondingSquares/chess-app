class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y)
      pawn_capture?(color, to_x, to_y)
    else
      (pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y)) || can_enpassant?
    end
  end

  def can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  #logic to perform enpassant
  def move_to!(to_x, to_y)
    if can_enpassant?
      diagonal_enpassant_move(to_x, to_y)
      capture_piece!(to_x, to_y, @opponent_pawn)
    else
      super
    end
  end
  
  #boolean for enpassant
  def can_enpassant?
    opponent_pawn_adjacent? && @opponent_pawn.moved_two_squares_first_turn?
  end
  
  
  
  #determines if piece has moved two squares to be captured
  def moved_two_squares_first_turn?
    turn == 1 && (y_pos == 3 || y_pos == 4)
  end
      
  #determines if opponent pawn is in position for enpassant
  def opponent_pawn_adjacent?
    x = self.x_pos - 1 || self.x_pos + 1
    y = self.y_pos
      if piece_exists?(x, y) && piece_exists?(x,y).name == "Pawn" && piece_exists?(x,y).color != self.color
        @opponent_pawn = piece_exists?(x,y)
        true
      else
        false
      end
  end
  
  #allows for a diagnol enpassant move
  def diagonal_enpassant_move(to_x, to_y)
    x = @opponent_pawn.x_pos

    if is_white?
      to_x == x && to_y == self.y_pos + 1
    elsif
      to_x == x && to_y == self.y_pos - 1
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