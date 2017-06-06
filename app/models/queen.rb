class Queen < Piece

	def queen_valid_move?(to_x, to_y)
    queen_move_horizontal?(to_x) || queen_move_vertical?(to_y) || queen_move_diagonal?(to_x, to_y)
  end

  private

  def queen_move_horizontal?(to_x)
    right_or_left(to_x) != 0 && to_x == starting_point_x + right_or_left(to_x)
  end

  def queen_move_vertical?(to_y)
    up_or_down(to_y) != 0 && to_y == starting_point_y + up_or_down(to_y)
  end

  def queen_move_diagonal?(to_x, to_y)
    queen_move_horizontal?(to_x) && queen_move_vertical?(to_y)
  end  

end