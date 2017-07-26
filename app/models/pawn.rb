class Pawn < Piece

  def icon
    '&#9823;'
  end

  def valid_move?(to_x, to_y)
    if is_on_square?(to_x, to_y)
      pawn_capture?(color, to_x, to_y)
    else
      (pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y)) || can_enpassant?(to_x, to_y)
    end
  end

  def can_promote?(y_pos)
    reached_opposite_border?(y_pos)
  end
  
  #logic to perform enpassant move
  def move_to!(to_x, to_y)
    if can_enpassant_left?(to_x, to_y)
      enpassant_capture!(to_x, to_y)
    elsif can_enpassant_right?(to_x, to_y)
      enpassant_capture!(to_x, to_y)
    elsif valid_move?(to_x, to_y)
      super
    end
  end

  def enpassant_capture!(to_x, to_y)
    capture_piece!(to_x, to_y, @opponent_pawn)
  end
  
  #boolean for enpassant
  def can_enpassant?(to_x, to_y)
    can_enpassant_left?(to_x, to_y) || can_enpassant_right?(to_x, to_y)
    # opponent_pawn_adjacent? && @opponent_pawn.moved_two_squares_first_turn?
  end
  
  #determines if piece has moved two squares to be captured
  def moved_two_squares_first_turn?
    turn == 1 && (y_pos == 3 || y_pos == 4)
  end

  def opponent_pawn_exists?(x, y)
    opposite_color = "Black" if self.color == "White"
    opposite_color = "White" if self.color == "Black"

    @opponent_pawn = game.pieces.find_by(x_pos: x, y_pos: y, name: "Pawn", color: opposite_color)
  end

  def enpassantable_destination?(to_x, to_y)
    x = @opponent_pawn.x_pos
    y_up_1 = @opponent_pawn.y_pos + 1
    y_down_1 = @opponent_pawn.y_pos - 1

    if is_white?
      to_x == x && to_y == y_up_1
    elsif is_black?
      to_x == x && to_y == y_down_1
    end
  end
      
  def opponent_pawn_adjacent_left
    x = self.x_pos - 1
    y = self.y_pos

    return opponent_pawn_exists?(x, y)
  end

  def can_enpassant_left?(to_x, to_y)
    if opponent_pawn_adjacent_left && enpassantable_destination?(to_x, to_y)
      opponent_pawn_adjacent_left.moved_two_squares_first_turn?
    else
      false
    end
  end

  def opponent_pawn_adjacent_right
    x = self.x_pos + 1
    y = self.y_pos

    return opponent_pawn_exists?(x, y)
  end

  def can_enpassant_right?(to_x, to_y)
    if opponent_pawn_adjacent_right && enpassantable_destination?(to_x, to_y)
      opponent_pawn_adjacent_right.moved_two_squares_first_turn?
    else
      false
    end
  end

  #determines if opponent pawn is in position for enpassant
  # def opponent_pawn_adjacent?
  #   opponent_pawn_adjacent_left || opponent_pawn_adjacent_right
    # x = self.x_pos - 1 || self.x_pos + 1
    # y = self.y_pos

    # if piece_exists?(x, y) && piece_exists?(x,y).name == "Pawn" && piece_exists?(x,y).color != self.color
    #   @opponent_pawn = piece_exists?(x,y)
    #   true
    # else
    #   false
    # end
  # end
  
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