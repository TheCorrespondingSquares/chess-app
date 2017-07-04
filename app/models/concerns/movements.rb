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

  def horizontal_move?(to_x)
    right_or_left(to_x) != 0
  end

  def horizontal_move_only?(to_x, to_y)
    horizontal_move?(to_x) && !vertical_move?(to_y)
  end

  def horizontal_move_one_square?(to_x)
    horizontal_move?(to_x) && to_x == starting_point_x + right_or_left(to_x)
  end

  def vertical_move?(to_y)
    up_or_down(to_y) != 0
  end

  def vertical_move_only?(to_x, to_y)
    vertical_move?(to_y) && !horizontal_move?(to_x)
  end

  def vertical_move_one_square?(to_y)
    vertical_move?(to_y) && to_y == starting_point_y + up_or_down(to_y)
  end

  def diagonal_move?(to_x, to_y)
    (starting_point_x - to_x).abs == (starting_point_y - to_y).abs
  end

  def diagonal_move_one_square?(to_x, to_y)
    horizontal_move_one_square?(to_x) && vertical_move_one_square?(to_y)
  end

  def x_out_of_range?(x)
    x > 7 || x < 0
  end

  def y_out_of_range?(y)
    y > 7 || y < 0
  end

end
