class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	after_create :populate_board
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }

  def self.populate_board(game_params)
	#white_pieces = [['Rook', 'Knight', 'Bishop', 'King', 'Queen', 'Bishop', 'Knight', 'Rook'], ['Pawn', 'Pawn','Pawn','Pawn','Pawn','Pawn','Pawn','Pawn']]
	#black_pieces = [['Pawn', 'Pawn','Pawn','Pawn','Pawn','Pawn','Pawn','Pawn'], ['Rook', 'Knight', 'Bishop', 'King', 'Queen', 'Bishop', 'Knight', 'Rook']]
	game = Game.create(game_params)
		(0..7).each do |w|
			Pawn.create(
			game_id: game.id,
        	x_pos: w,
        	y_pos: 1,
        	color: true
        	)
        end
		        
			Rook.create(game_id: game.id, x_pos: 0, y_pos: 0, color: true)
		    Rook.create(game_id: game.id, x_pos: 7, y_pos: 0, color: true)
		
		    Knight.create(game_id: game.id, x_pos: 1, y_pos: 0, color: true)
		    Knight.create(game_id: game.id, x_pos: 6, y_pos: 0, color: true)
		
		    Bishop.create(game_id: game.id, x_pos: 2, y_pos: 0, color: true)
		    Bishop.create(game_id: game.id, x_pos: 5, y_pos: 0, color: true)
		
		    Queen.create(game_id: game.id, x_pos: 3, y_pos: 0, color: true)
		    King.create(game_id: game.id, x_pos: 4, y_pos: 0, color: true)

	    # Black Pieces
	    (0..7).each do |b|
	      Pawn.create(
	        game_id: game.id,
	        x_pos: b,
	        y_pos: 6,
	        color: false
	        )
	      end
	
	    Rook.create(game_id: game.id, x_pos: 0, y_pos: 7, color: false)
	    Rook.create(game_id: game.id, x_pos: 7, y_pos: 7, color: false)
	
	    Knight.create(game_id: game.id, x_pos: 1, y_pos: 7, color: false)
	    Knight.create(game_id: game.id, x_pos: 6, y_pos: 7, color: false)
	
	    Bishop.create(game_id: game.id, x_pos: 2, y_pos: 7, color: false)
	    Bishop.create(game_id: game.id, x_pos: 5, y_pos: 7, color: false)
	
	    Queen.create(game_id: game.id, x_pos: 3, y_pos: 7, color: false)
	    King.create(game_id: game.id, x_pos: 4, y_pos: 7, color: false)
	  game
  end
  
	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end