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
  
  def castle(to_x, to_y)
  rook = game.pieces.find_by(name: 'Rook', game_id: game.id, color: color)
    return false if !self.moved? && !rook.moved? && !king.check?
        if self.valid_move?(to_x) == 2
          self.move_to!(2, y_pos) && rook.move_to!(3, y_pos)
        elsif self.valid_move?(to_x) == 6
          self.move_to!(6, y_pos) && rook.move_to!(5, y_pos)
        end
  end
end