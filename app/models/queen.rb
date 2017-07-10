class Queen < Piece
after_create :icon
    
  def icon
    # if color == "White"
    #   '&#9813;'
    # else
    #   '&#9819;'
    # end
    '&#9819;'
  end

  def valid_move?(to_x, to_y)
    return false if friendly_piece_on_square?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    horizontal_move_only?(to_x, to_y) || vertical_move_only?(to_x, to_y) || diagonal_move?(to_x, to_y)
  end

end