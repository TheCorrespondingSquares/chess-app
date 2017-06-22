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
    castle(to_x, to_y) || horizontal_move_one_square?(to_x) || vertical_move_one_square?(to_y) || diagonal_move_one_square?(to_x, to_y)
  end
  
  def castle(to_x)
  rook = game.pieces.find_by(name: 'Rook', game_id: game.id, color: color)
    if self.moved? && rook.moved? && king.check?
      raise 'cannot castle!'
    elsif self.valid_move?(to_x: 2, y_pos: y_pos)
      self.update(x_pos: 2, y_pos: y_pos) && rook.update(x_pos: 3, y_pos: y_pos)
    elsif self.valid_move?(to_x: 6, y_pos: y_pos)
      self.update(x_pos: 6, y_pos: y_pos) && rook.update(x_pos: 5, y_pos: y_pos)
    else
      nil
    end
  end
end