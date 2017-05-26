class Game < ApplicationRecord
	has_many :pieces
	
	def self.available
	  where(available: true) if :user_id.count == 1 && :private != true
	end

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
