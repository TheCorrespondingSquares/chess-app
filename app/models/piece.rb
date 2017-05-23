class Piece < ApplicationRecord

  # Check if a piece exists at the given coordinates in the current game
  def is_on_square?(x, y) ### needs game/piece association to really work
    pieces = Piece.all
    return pieces.exists?(x_pos: x, y_pos: y)
  end

  # Check for obstructions between a piece's start and destination positions
  def is_obstructed?(x_dest, y_dest)
    # Return an error message if the piece is a knight (knights can't be obstructed)
    return "error - invalid input" if self.name == "knight"

    x_start = self.x_pos
    y_start = self.y_pos

    # Create variable for horizontal movement (positive for right, negative for left)
    x_move = 1 if x_start < x_dest
    x_move = -1 if x_start > x_dest
    # Create variable for vertical movement (positive for up, negative for down)
    y_move = 1 if y_start < y_dest
    y_move = -1 if y_start > y_dest

    # Initialize variables to record movements, which can be checked against existing pieces
    x_check = x_start + x_move
    y_check = y_start + y_move

    # Check for vertical obstructions
    if x_start == x_dest
      y_check = y_start + y_move

      while y_check != y_dest
        return true if is_on_square?(x_dest, y_check)
        y_check += y_move
      end

      return false
    # Check for horizontal obstructions
    elsif y_start == y_dest
      x_check = x_start + x_move

      while x_check != x_dest
        return true if is_on_square?(x_check, y_dest)
        x_check += x_move
      end

      return false
    # Check for diagonal obstructions
    else
      x_check = x_start + x_move
      y_check = y_start + y_move

      while x_check != x_dest && y_check != y_dest
        return true if is_on_square?(x_check, y_check)
        x_check += x_move
        y_check += y_move
      end

      return false
    end
  end # end of is_obstructed? method

end
