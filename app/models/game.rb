class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	after_create :populate_board!
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }
	
def populate_board!
  #white_piece
	(0..1).each do |row|
	  (0..7).each do |col|
			if row.eql?(1)
			  Pawn.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)
			elsif (row.eql?(0) && col.eql?(0)) || (row.eql?(0) && col.eql?(7))
			  Rook.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)
	    elsif (row.eql?(0) && col.eql?(1)) || (row.eql?(0) && col.eql?(6))
			  Bishop.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)
	    elsif (row.eql?(0) && col.eql?(2)) || (row.eql?(0) && col.eql?(5))
			  Knight.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)
	    elsif row.eql?(0) && col.eql?(3)
			  Queen.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)
	    elsif row.eql?(0) && col.eql?(4)
	      King.create(color: 'White', game_id: self.id, x_pos: col, y_pos: row)    	
	    end
	  end
  end
  #black_pieces
  (6..7).each do |row|
		(0..7).each do |col|
			if row.eql?(6)
			  Pawn.create(color: 'Black', game_id: self.id, x_pos: col, y_pos: row)
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
  end
end
  
	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end