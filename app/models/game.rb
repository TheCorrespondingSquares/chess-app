class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	after_create :populate_board!
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }
	
	def populate_board!
	  # ------ Black pieces -----------
	  8.times do |i|
	  	Pawn.create(color: 'Black', game_id: self.id, x_pos: i, y_pos: 1)
	  end
	  
		big_pieces.each_with_index do |piece, i|
			Piece.create(name: piece, color: 'Black', game_id: self.id, x_pos: i, y_pos: 0)
		end
<<<<<<< HEAD
	  #black_pieces
	  (6..7).each do |row|
		(0..7).each do |col|
		  if row.eql?(6)
			  Pawn.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row, icon: '&#9817;')
		  elsif (row.eql?(7) && col.eql?(0)) || (row.eql?(7) && col.eql?(7))
			  Rook.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)
		  elsif (row.eql?(7) && col.eql?(1)) || (row.eql?(7) && col.eql?(6))
			  Bishop.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)
		  elsif (row.eql?(7) && col.eql?(2)) || (row.eql?(7) && col.eql?(5))
			  Knight.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)
		  elsif row.eql?(7) && col.eql?(3)
			  Queen.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)
		  elsif row.eql?(7) && col.eql?(4)
		      King.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)    	
		  end
		end
=======
	  # ------ White pieces ----------
		
		8.times do |i|
	  	Pawn.create(color: 'White', game_id: self.id, x_pos: i, y_pos: 6)
>>>>>>> ce084b32cd34a359dfc9e9cf411d1cf3895d3fbe
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