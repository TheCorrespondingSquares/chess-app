class Piece < ApplicationRecord

  # Define movement
  def x_start
    @x_start = self.x_pos
  end

  def y_start
    @y_start = self.y_pos
  end

  def right_left(x_dest)
    return 1 if x_start < x_dest
    return -1 if x_start > x_dest
  end
  
  def up_down(y_dest)
    return 1 if y_start < y_dest
    return -1 if y_start > y_dest
  end

  # Check for occupied square
  def occupied_squares  # ****needs game association***
    @occupied_squares ||= Piece.all.pluck(:x_pos, :y_pos)
  end
  
  def is_on_square?(x, y)
    occupied_squares.include?([x, y])
  end

  # Check for obstructions
  def knight_cant_be_obstructed
    return "error - invalid input" if self.name == "knight"
  end

  def horizontal_obstruction?(x_dest, y)
    knight_cant_be_obstructed
    move_x = x_start + right_left(x_dest)

    while move_x != x_dest
      return true if is_on_square?(move_x, y)
      move_x += right_left(x_dest)
    end

    return false
  end    

  def vertical_obstruction?(x, y_dest)
    knight_cant_be_obstructed
    move_y = y_start + up_down(y_dest)

    while move_y != y_dest
      return true if is_on_square?(x, move_y)
      move_y += up_down(y_dest)
    end

    return false
  end

  def diagonal_obstruction?(x_dest, y_dest)
    knight_cant_be_obstructed
    move_x = x_start + right_left(x_dest)
    move_y = y_start + up_down(y_dest)

    while move_x != x_dest && move_y != y_dest
      return true if is_on_square?(move_x, move_y)
      move_x += right_left(x_dest)
      move_y += up_down(y_dest)
    end

    return false
  end

  def is_obstructed?(x_dest, y_dest)
    knight_cant_be_obstructed
    if y_start == y_dest # If y doesn't change, movement is horizontal
      horizontal_obstruction?(x_dest, y_dest)
    elsif x_start == x_dest # If x doesn't change, movement is vertical
      vertical_obstruction?(x_dest, y_dest)
    else # If x and y change, movement is diagonal
      diagonal_obstruction?(x_dest, y_dest)
    end
  end

end
