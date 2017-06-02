class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	validates :name, presence: true
	after_create :populate_board!
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }
	
private

  def populate_board!
  	#white_piece
	(0..1).each do |row|
	  (0..7).each do |col|
		if row.eql?(1)
		  Rook.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
		end
		if row.eql?(0) && col.eql?(0) && col.eql?(7)
		  Rook.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
		end
        if row.eql?(0) && col.eql?(1) && col.eql?(6)
		  Bishop.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        end
        if row.eql?(0) && col.eql?(2) && col.eql?(5)
		  Knight.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        end
        if row.eql?(0) && col.eql?(3)
		  Queen.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        else
          King.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)    	
        end
      end
    end
    #black_pieces
    (6..7).each do |row|
	  (0..7).each do |col|
		if row.eql?(6)
		  Rook.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
		end
		if row.eql?(7) && col.eql?(0) && col.eql?(7)
		  Rook.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
		end
        if row.eql?(7) && col.eql?(1) && col.eql?(6)
		  Bishop.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        end
        if row.eql?(7) && col.eql?(2) && col.eql?(5)
		  Knight.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        end
        if row.eql?(7) && col.eql?(4)
		  Queen.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)
        else
          King.create(captured: false, game_id: self.id, x_pos: col, y_pos: row)    	
        end
      end
    end
  end
  
	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end