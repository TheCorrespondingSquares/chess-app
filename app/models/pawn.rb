class Pawn < Piece

  def valid_move?(to_x, to_y)
    if pawn_move_diagonal?(to_x, to_y)
      if is_on_square?(to_x, to_y)
        #move_to!(to_x, to_y)
        return true
      else
        return false
      end
    end
    pawn_move_vertical?(to_x, to_y) && vertical_move_only?(to_x, to_y) 
  end
  
  def move_to!(params)
    if can_promote?(to_y) && valid_move?(to_x, to_y)
      promote_pawn(name)
    else
      super(params)
    end
  end

  private

  def pawn_capture?(to_x, to_y)
    move_to!(to_x, to_y)
  end

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
  
  def can_promote?(to_y)
    reached_opposite_border?(to_y)
  end
  
  def reached_opposite_border?(to_y)
    white_reached_border?(to_y) || black_reached_border?(to_y)
  end
  
  def white_reached_border?(to_y)
    to_y == 7 && is_white?
  end
  
  def black_reached_border?(to_y)
    to_y == 7 && is_black?
  end
  
  def promote_pawn(name)
    self.update_attributes(name: name)
  end

end