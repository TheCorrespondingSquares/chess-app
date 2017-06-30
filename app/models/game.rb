class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	after_create :populate_board!
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }
	
	def populate_board!
	  # ------ Black pieces ----------
		8.times do |i|
	  	Pawn.create(color: 'Black', game_id: self.id, x_pos: i, y_pos: 1, icon:"&#9817;")
		end
		big_pieces.each_with_index do |piece, i|
			Piece.create(name: piece, color: 'Black', game_id: self.id, x_pos: i, y_pos: 0)
		end

		# ------ White pieces -----------
	  8.times do |i|
	  	Pawn.create(color: 'White', game_id: self.id, x_pos: i, y_pos: 6, icon: "&#9823;")
	  end
		big_pieces.each_with_index do |piece, i|
			Piece.create(name: piece, color: 'White', game_id: self.id, x_pos: i, y_pos: 7)
		end
	end

	def big_pieces
		%w(Rook Knight Bishop Queen King Bishop Knight Rook)
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

  def checkmate?(color)
    generate_king_and_opposite_pieces(color)

  	return false unless check?(color)
  	return false if king_can_be_blocked?(color)
  	return false if king_can_capture_piece?(color)
  	return false if @king.is_able_to_escape_check?

  	true
  end

  def king_can_capture_piece?(color)
  	generate_king_and_opposite_pieces(color)

  	x = @piece_making_check.x_pos
  	y = @piece_making_check.y_pos

  	@king.valid_move?(x, y)
  end

  def king_can_be_blocked?(color)
  	true
  end

  def generate_king_and_opposite_pieces(color)
  	@king = pieces.find_by(name: 'King', color: color)
    @opposite_pieces = pieces.where(captured: false).where.not(color: color)
  end
  
	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
