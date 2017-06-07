class Queen < Piece

	def queen_valid_move?(to_x, to_y)
    if queen_move_horizontal?(to_x) && queen_move_vertical?(to_y)
      queen_move_diagonal?(to_x, to_y)
    else
      queen_move_horizontal?(to_x) || queen_move_vertical?(to_y)
    end
  end

  private

  def queen_move_horizontal?(to_x)
    right_or_left(to_x) != 0
  end

  def queen_move_vertical?(to_y)
    up_or_down(to_y) != 0
  end

  def queen_move_diagonal?(to_x, to_y)
    (starting_point_x - to_x).abs == (starting_point_y - to_y).abs
  end  

end