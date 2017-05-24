class Game < ApplicationRecord
	has_many :pieces
	
	scope :available, ->{ where(available: true)}

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
