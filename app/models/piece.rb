class Piece < ApplicationRecord
	belongs_to :user
	belongs_to :game

	self.inheritance_column = :name

	scope :kings,	-> { where(name: 'King') }
	scope :queens, 	-> { where(name: 'Queen') }
	scope :bishops, -> { where(name: 'Bishop') }
	scope :knights, -> { where(name: 'Knight') }
	scope :rooks,	-> { where(name: 'Rook') }
	scope :pawns, 	-> { where(name: 'Pawn') }

	def self.names
		%w(King Queen Bishop Knight Rook Pawn)
	end

  include Movements
  include Squares
  include Obstructions

end
