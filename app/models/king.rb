class King < Piece
after_create :icon
    
  def icon
    if color == "White"
      '&#9812;'
    else
      '&#9818;'
    end
  end

  def valid_move?(to_x, to_y)
    horizontal_move_one_square?(to_x) || vertical_move_one_square?(to_y) || diagonal_move_one_square?(to_x, to_y)
  end
  
  def castle(to_x, to_y)
    rook = game.pieces.find_by(name: 'Rook', game_id: game.id, color: color)
    if !self.moved? && !rook.moved? && !occupied_squares && !self.check?
      self.update(x_pos: x_pos - 2, y_pos: y_pos) && rook.update(x_pos: x_pos + 2, y_pos: y_pos)
    else
      nil
    end
  end
  
end