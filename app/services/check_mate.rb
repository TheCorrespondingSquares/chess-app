class CheckMate
	attr_accessor :game, :king_color, :king

	def initialize(game, king_color)
		@game = game
		@king_color = king_color
		@king = pieces.find_by(name: 'King', color: color)
	end

	def call
		generate_king_and_opposite_pieces(color)

  	return false unless check?(color)
  	# return false if king_can_be_blocked?(color)
  	# return false if king_can_capture_piece?(color)
  	return false if king.is_able_to_escape_check?

  	true
	end

	private

  def generate_king_and_opposite_pieces(color)
  	
    @opposite_pieces = pieces.where(captured: false).where.not(color: color)
  end

  def check?(color)
    generate_king_and_opposite_pieces(color)

    @opposite_pieces.each do |piece|
      if piece.valid_move?(@king.x_pos, @king.y_pos)
        @piece_making_check = piece
        return true
      end
    end
    false
  end
end