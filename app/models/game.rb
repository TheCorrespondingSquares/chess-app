class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }

	def populate_board(game_params)
		game = Game.create(game_params)
		white_pieces.each_with_index do |pieces, row|
			pieces.each_with_index do |piece, col|
				Piece.create(name: piece, game_id: game.id, x_pos: row, y_pos: col)
			end
		end
		black_pieces.each_with_index do |pieces, row|
			pieces.each_with_index do |piece, col|
				Piece.create(name: piece, game_id: game.id, x_pos: row + 6, y_pos: col)
			end
		end
		game
	end

	white_pieces = [['Rook', 'Knight', 'Bishop', 'King', 'Queen', 'Bishop', 'Knight', 'Rook'], ['Pawn', 'Pawn','Pawn','Pawn','Pawn','Pawn','Pawn','Pawn']]
	black_pieces = [['Pawn', 'Pawn','Pawn','Pawn','Pawn','Pawn','Pawn','Pawn'], ['Rook', 'Knight', 'Bishop', 'King', 'Queen', 'Bishop', 'Knight', 'Rook']]

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
