class King < Piece

  def king_valid_move?(to_x, to_y)
    king_move_horizontal?(to_x) || king_move_vertical?(to_y) || king_move_diagonal?(to_x, to_y)
  end

  private

  def king_move_horizontal?(to_x)
    to_x == starting_point_x + right_or_left(to_x) && right_or_left(to_x) != 0
  end

  def king_move_vertical?(to_y)
    to_y == starting_point_y + up_or_down(to_y) && up_or_down(to_y) != 0
  end

  def king_move_diagonal?(to_x, to_y)
    king_move_horizontal?(to_x) && king_move_vertical?(to_y)
  end  

end