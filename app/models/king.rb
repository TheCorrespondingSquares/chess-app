class King < Piece
after_create :icon
    
  def icon
    # if color == "White"
    #   '&#9812;'
    # else
    #   '&#9818;'
    # end
    '&#9818;'
  end

  def valid_move?(to_x, to_y)
    horizontal_move_one_square?(to_x) || vertical_move_one_square?(to_y) || diagonal_move_one_square?(to_x, to_y)
  end

  def is_able_to_escape_check?
    ((x_pos - 1)..(x_pos + 1)).each do |x|
      next if x_out_of_range?(x)
      ((y_pos - 1 )..(y_pos + 1)).each do |y|
        next if y_out_of_range?(y)
        if !is_on_square?(x, y) && valid_move?(x, y) && !game.possible_check?(self.color, x, y)
          return true
        end
      end
    end
    false
  end

end