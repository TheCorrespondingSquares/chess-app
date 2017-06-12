class Rook < Piece
after_create :icon

  def icon
    if color == "White"
      '&#9814;'
    else
      '&#9820;'
    end
  end


  def rook_valid_move?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    horizontal_move?(to_x, to_y) || vertical_move?(to_y, to_x)
  end
end
