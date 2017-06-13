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
    only_horizontal_move?(to_x, to_y) || only_vertical_move?(to_x, to_y) || diagonal_move?(to_x, to_y)
  end

end