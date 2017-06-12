module Obstructions

  # Check for obstructions
  def is_obstructed?(destination_x, destination_y)
    # Knights can't be obstructed
    return "invalid" if self.name == "Knight"

    if starting_point_y == destination_y                    # If y doesn't change, movement is horizontal
      horizontal_obstruction?(destination_x, destination_y)
    elsif starting_point_x == destination_x                 # If x doesn't change, movement is vertical
      vertical_obstruction?(destination_x, destination_y)
    else                                                    # If x and y change, movement is diagonal
      diagonal_obstruction?(destination_x, destination_y)
    end
  end

  private

  # Check for horizontal obstruction
  def horizontal_obstruction?(destination_x, y)
    move_x = starting_point_x + right_or_left(destination_x)

    while move_x != destination_x
      return true if is_on_square?(move_x, y)
      move_x += right_or_left(destination_x)
    end

    return false
  end

  # Check for vertical obstruction
  def vertical_obstruction?(x, destination_y)
    move_y = starting_point_y + up_or_down(destination_y)

    while move_y != destination_y
      return true if is_on_square?(x, move_y)
      move_y += up_or_down(destination_y)
    end

    return false
  end

  # Check for diagonal obstruction
  def diagonal_obstruction?(destination_x, destination_y)
    move_x = starting_point_x + right_or_left(destination_x)
    move_y = starting_point_y + up_or_down(destination_y)

    while move_x != destination_x && move_y != destination_y
      return true if is_on_square?(move_x, move_y)
      move_x += right_or_left(destination_x)
      move_y += up_or_down(destination_y)
    end

    return false
  end

end
