class CheckMate
	attr_accessor :game, :king_color, :king, :opposite_pieces, :friendly_pieces

	def initialize(game, king_color)
		@game = game
		@king_color = king_color
		@king = @game.pieces.find_by(name: 'King', color: king_color)
    @opposite_pieces = @game.pieces.where(captured: false).where.not(color: king_color)
    @friendly_pieces = @game.pieces.where(captured: false).where(color: king_color)
	end

	def call
  	return false unless check?
  	return false if king_can_be_blocked? || king_can_capture_piece? || king.is_able_to_escape_check?
  	true
	end

	private

  def check?
    opposite_pieces.each do |piece|
      if piece.valid_move?(king.x_pos, king.y_pos)
        @piece_making_check = piece
        return true
      end
    end
    false
  end

  def king_can_be_blocked?

    obstruction_path = []
    starting_x = @piece_making_check.x_pos
    starting_y = @piece_making_check.y_pos

    (starting_x...king.x_pos).each do |x|
      (starting_y...king.y_pos).each do |y|
        obstruction_path.push([x, y]) if @piece_making_check.valid_move?(x, y)
      end
    end

    friendly_pieces.each do |piece|
      next if piece.name == 'King'
      obstruction_path.each do |square|
        return true if piece.valid_move?(square[0], square[1])
      end
    end
    false
  end

  def king_can_capture_piece?
    x = @piece_making_check.x_pos
    y = @piece_making_check.y_pos
    king.valid_move?(x, y)
  end

end