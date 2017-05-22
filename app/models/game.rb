class Game < ApplicationRecord
	has_many :pieces
	belongs_to :user

	delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces
end