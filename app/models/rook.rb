class Rook < Piece
after_create :icon
delegate :rook, to: :king, prefix: true

  def icon
    if color == "White"
      '&#9814;'
    else
      '&#9820;'
    end
  end

  def valid_move?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    horizontal_move_only?(to_x, to_y) || vertical_move_only?(to_x, to_y)
  end
  
end
