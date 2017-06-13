class Rook < Piece
after_create :icon

  def icon
    if color == "White"
      '&#9814;'
    else
      '&#9820;'
    end
  end

  def valid_move?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    only_horizontal_move?(to_x, to_y) || only_vertical_move?(to_x, to_y)
  end
  
end
