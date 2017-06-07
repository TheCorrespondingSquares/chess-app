class Queen < Piece
after_create :icon
    
  def icon
    if color == "White"
      '&#9813;'
    else
      '&#9819;'
    end
  end
end