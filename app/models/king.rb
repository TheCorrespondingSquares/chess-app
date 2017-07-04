class King < Piece
after_create :icon
    
  def icon
    # if color == "White"
    #   '&#9812;'
    # else
    #   '&#9818;'
    # end
    '&#9818;'
  end

  def valid_move?(to_x, to_y)
    horizontal_move_one_square?(to_x) || vertical_move_one_square?(to_y) || diagonal_move_one_square?(to_x, to_y)
  end

end