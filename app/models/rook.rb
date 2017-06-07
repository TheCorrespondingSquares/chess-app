class Rook < Piece
after_create :icon

  def icon
    if color == "White"
      '&#9814;'
    else
      '&#9820;'
    end
  end
end