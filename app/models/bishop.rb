class Bishop < Piece
  after_create :icon
    
  def icon
    if color == "White"
      '&#9815;'
    else
      '&#9821;'
    end
  end

  def valid_move?(to_x, to_y)
    return false if self.is_obstructed?(to_x, to_y)
    diagonal_move?(to_x, to_y)
  end

end
