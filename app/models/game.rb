class Game < ApplicationRecord
	has_many :pieces

	scope :available, -> { where(user_id: nil) }

	def available?
		user_id.blank?
	end

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end
