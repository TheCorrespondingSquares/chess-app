class Knight < Piece
after_create :icon

  def icon
    if color == "White"
      '&#9816;'
    else
      '&#9822;'
    end
  end

  def knight_valid_move?(to_x, to_y)
    knight_move_wide? || knight_move_tall?
  end

  private

  def knight_move_wide?(to_x, to_y)
    (starting_point_x - to_x).abs == 2 && (starting_point_y - to_y).abs == 1
  end

  def knight_move_tall?(to_x, to_y)
    (starting_point_x - to_x).abs == 1 && (starting_point_y - to_y).abs == 2
  end
end