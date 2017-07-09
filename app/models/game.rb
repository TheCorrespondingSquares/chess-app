class Game < ApplicationRecord
  include Squares

  has_many :pieces
  belongs_to :white_player, class_name: "User", optional: true
  belongs_to :black_player, class_name: "User", optional: true
  validates :name, presence: true
  after_create :populate_board!
  
  scope :available, -> { where('white_player_id is NULL OR black_player_id is NULL') }
  
  def populate_board!
    # ------ White pieces -----------
    8.times do |i|
      Pawn.create(color: 'White', game_id: self.id, x_pos: i, y_pos: 1, icon: "&#9817;")
    end
    big_pieces.each_with_index do |piece, i|
      Piece.create(name: piece, color: 'White', game_id: self.id, x_pos: i, y_pos: 0)
    end
    # ------ Black pieces ----------
    8.times do |i|
      Pawn.create(color: 'Black', game_id: self.id, x_pos: i, y_pos: 6, icon:"&#9823;")
    end
    big_pieces.each_with_index do |piece, i|
      Piece.create(name: piece, color: 'Black', game_id: self.id, x_pos: i, y_pos: 7)
    end
  end

  def big_pieces
    %w(Rook Knight Bishop Queen King Bishop Knight Rook)
  end
  
  #makes sure both present to start game
  def game_full?
    white_player_id.present? && black_player_id.present?
  end

  #white player goes first
  def white_goes_first
    self.turn == 0
  end
  
  def white_piece_turn?
    white_goes_first || self.turn.even?
  end

  def black_piece_turn?
    !white_piece_turn?
  end
      
  def check?(color)
    generate_king_and_opposite_pieces(color)

    @opposite_pieces.each do |piece|
      if piece.valid_move?(@king.x_pos, @king.y_pos)
        @piece_making_check = piece
        return true
      end
    end
    false
  end
  
  def possible_check?(color, x, y)
    generate_king_and_opposite_pieces(color)

    @opposite_pieces.each do |piece|
      if piece.valid_move?(x, y)
        @piece_making_check = piece
        return true
      end
    end
    false
  end

  def checkmate?(color)
  	CheckMate.new(self, color).call
  end

  def friendly_pieces(color)
    return pieces.where(color: color).where(captured: false)
  end

  def stalemate?(color)
    results_in_check = []

    friendly_pieces(color).each do |piece|
      start_x = piece.x_pos
      start_y = piece.y_pos

      piece.all_valid_moves.each do |move|
        x = move[0]
        y = move[1]
        
        piece.transaction do   
          piece.move_to!(x, y)
          results_in_check << check?(piece.color)
          piece.move_to!(start_x, start_y)
          raise ActiveRecord::Rollback          
        end
      end
    end

    !results_in_check.include?(false)
  end

  delegate :kings, :queens, :bishops, :knights, :rooks, :pawns, to: :pieces

  private

  def generate_king_and_opposite_pieces(color)
    @king = pieces.find_by(name: 'King', color: color)
    @opposite_pieces = pieces.where(captured: false).where.not(color: color)
  end

end
