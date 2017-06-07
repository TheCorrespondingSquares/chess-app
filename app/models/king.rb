class King < Piece
after_create :icon
    
  def icon
    if color == "White"
      '&#9812;'
    else
      '&#9818;'
    end
  end
end