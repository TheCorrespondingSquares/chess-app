class Knight < Piece
after_create :icon

  def icon
    if color == "White"
      '&#9816;'
    else
      '&#9822;'
    end
  end
end