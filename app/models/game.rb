class Game < ApplicationRecord
	has_many :pieces

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
