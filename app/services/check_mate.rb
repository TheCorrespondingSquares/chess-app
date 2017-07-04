class CheckMate
	attr_accessor :game, :king_color, :king, :opposite_pieces

	def initialize(game, king_color)
		@game = game
		@king_color = king_color
		@king = @game.pieces.find_by(name: 'King', color: king_color)
    @opposite_pieces = @game.pieces.where(captured: false).where.not(color: king_color)
	end

	def call
  	return false unless check?(king_color)
  	# return false if king_can_be_blocked?(color)
  	return false if king_can_capture_piece?(king_color)
  	return false if king.is_able_to_escape_check?

  	true
	end

	private

  # def generate_king_and_opposite_pieces(color)
  #   @opposite_pieces = pieces.where(captured: false).where.not(color: color)
  # end

  def check?(color)
    opposite_pieces.each do |piece|
      if piece.valid_move?(king.x_pos, king.y_pos)
        @piece_making_check = piece
        return true
      end
    end
    false
  end

  def king_can_be_blocked?(color)
    # true
  end

  def king_can_capture_piece?(color)
    x = @piece_making_check.x_pos
    y = @piece_making_check.y_pos
    king.valid_move?(x, y)
  end

end