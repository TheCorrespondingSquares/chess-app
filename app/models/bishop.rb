class Bishop < Piece
  after_create :icon
    
  def icon
    if color == "White"
      '&#9815;'
    else
      '&#9821;'
    end
  end

  def bishop_valid_move?(to_x, to_y)
    bishop_move_diagonal?(to_x, to_y)
  end

  private

  def bishop_move_horizontal?(to_x)
    right_or_left(to_x) != 0
  end

  def bishop_move_vertical?(to_y)
    up_or_down(to_y) != 0
  end

  def bishop_move_diagonal?(to_x, to_y)
    (starting_point_x - to_x).abs == (starting_point_y - to_y).abs
  end  

end