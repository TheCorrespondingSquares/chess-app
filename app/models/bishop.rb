class Bishop < Piece
  after_create :icon
    
  def icon
    if color == "White"
      '&#9815;'
    else
      '&#9821;'
    end
  end
  
  def rook_valid_move?(to_x, to_y)
    return false if self.is_obstructed(to_x, to_y)
    rook.horizantal_move?(to_y) || rook.vertical_move?(to_x)
  end

  private
  
  def horizantal_move?(to_y)
    if to_y != starting_point_y
    end
  end
  
  def vertical_move?(to_x)
    if to_y != starting_point_x
    end
  end
end
