class Bishop < Piece
  after_create :icon
    
  def icon
    if color == "White"
      '&#9815;'
    else
      '&#9821;'
    end
  end

end