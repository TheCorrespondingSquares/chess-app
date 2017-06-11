module Movements

  def starting_point_x
    @starting_point_x = self.x_pos
  end

  def starting_point_y
    @starting_point_y = self.y_pos
  end

  def right_or_left(destination_x)
    return 1 if starting_point_x < destination_x
    return -1 if starting_point_x > destination_x
    return 0 if starting_point_x == destination_x
  end

  def up_or_down(destination_y)
    return 1 if starting_point_y < destination_y
    return -1 if starting_point_y > destination_y
    return 0 if starting_point_y == destination_y
  end

  def horizontal_move?(to_x, to_y)
    to_x != starting_point_x && starting_point_y == to_y
  end

  def vertical_move?(to_y, to_x)
    to_y != starting_point_y && starting_point_x == to_x
  end

end
