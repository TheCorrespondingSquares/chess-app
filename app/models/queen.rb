class Queen < Piece
after_create :icon
    
  def icon
    if color == "White"
      '&#9813;'
    else
      '&#9819;'
    end
  end

  def valid_move?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    horizontal_move_only?(to_x, to_y) || vertical_move_only?(to_x, to_y) || diagonal_move?(to_x, to_y)
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