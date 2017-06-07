class Pawn < Piece

	def pawn_valid_move?(to_x, to_y)
		if self.color == 'White' && self.y_pos == 1
			up_or_down(to_y) != 0 && to_y < 4
		elsif self.color == 'Black' && self.y_pos == 6
			up_or_down(to_y) != 0 && to_y > 3
		else
			pawn_move_vertical?(to_y)
		end
    # if queen_move_horizontal?(to_x) && queen_move_vertical?(to_y)
    #   queen_move_diagonal?(to_x, to_y)
    # else
    #   queen_move_horizontal?(to_x) || queen_move_vertical?(to_y)
    # end
  end

  private

  def pawn_move_horizontal?(to_x)
  	# Invalid move
    right_or_left(to_x) == 0
  end

  def pawn_move_vertical?(to_y)
  	up_or_down(to_y) != 0 && to_y == starting_point_y + up_or_down(to_y)
  end

  def pawn_move_diagonal?(to_x, to_y)
    (starting_point_x - to_x).abs == (starting_point_y - to_y).abs
  end 

end