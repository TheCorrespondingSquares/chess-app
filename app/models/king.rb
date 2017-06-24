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
    horizontal_move_one_square?(to_x) || vertical_move_one_square?(to_y) || diagonal_move_one_square?(to_x, to_y) || castle(to_x, to_y)
  end
  
  def castle(to_x, to_y)
  rook = game.pieces.find_by(name: 'Rook', game_id: game.id, color: color)
    return " Cannot Castle!" if self.moved? && rook.moved? && king.check?
    #right-side castle
      if rook.move_to!(to_x: 5, to_y: y_pos)
        self.update_attributes(x_pos: 6, y_pos: y_pos)
    #left-side castle
      elsif rook.move_to!(x_pos: 3, y_pos: y_pos)
        self.update_attributes(x_pos: 2, y_pos: y_pos)
      end
  end
end