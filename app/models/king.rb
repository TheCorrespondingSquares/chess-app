class King < Piece
after_create :icon
    
  def icon
    if color == "White"
      '&#9812;'
    else
      '&#9818;'
    end
  end

  def valid_move?(to_x, to_y)
    king_move_horizontal?(to_x) || king_move_vertical?(to_y) || king_move_diagonal?(to_x, to_y)
  end

  private

  def king_move_horizontal?(to_x)
    right_or_left(to_x) != 0 && to_x == starting_point_x + right_or_left(to_x)
  end

  def king_move_vertical?(to_y)
    up_or_down(to_y) != 0 && to_y == starting_point_y + up_or_down(to_y)
  end

  def king_move_diagonal?(to_x, to_y)
    king_move_horizontal?(to_x) && king_move_vertical?(to_y)
  end  

end