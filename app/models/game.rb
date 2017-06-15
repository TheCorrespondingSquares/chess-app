class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	validates :name, uniqueness: true
	after_create :populate_board!

	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }

	def populate_board!
	  # ------ Black pieces -----------
	  8.times do |i|
	  	Pawn.create(color: 'Black', game_id: self.id, x_pos: i, y_pos: 1, icon: "&#9823;")
	  end

		big_pieces.each_with_index do |piece, i|
			Piece.create(name: piece, color: 'Black', game_id: self.id, x_pos: i, y_pos: 0)
		end

	  # ------ White pieces ----------

	  8.times do |i|
	  	Pawn.create(color: 'White', game_id: self.id, x_pos: i, y_pos: 6, icon:"&#9817;")
	  end

		big_pieces.each_with_index do |piece, i|
			Piece.create(name: piece, color: 'White', game_id: self.id, x_pos: i, y_pos: 7)
		end

	end

	def big_pieces
		%w(Rook Bishop Knight Queen King Knight Bishop Rook)
	end

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
