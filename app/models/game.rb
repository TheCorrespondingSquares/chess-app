class Game < ApplicationRecord
	has_many :pieces
	belongs_to :white_player, class_name: "User", optional: true
	belongs_to :black_player, class_name: "User", optional: true
	
	scope :available,	-> { where('white_player_id is NULL OR black_player_id is NULL') }

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
