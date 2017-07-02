class PiecesController < ApplicationController
  before_action :require_game_player, only: [:update]

  def show
    render json: current_piece
  end

  def update
    piece = current_piece
    new_x_pos = params[:x_pos].to_i
    new_y_pos = params[:y_pos].to_i

    logger.info "Params:
    Orig x_pos: #{piece.x_pos.inspect}, Orig y_pos: #{piece.y_pos.inspect},
    Dest x_pos: #{new_x_pos.inspect}, Dest y_pos: #{params[:y_pos].to_i.inspect}"

    @game = piece.game
    @turn = @game.turn
    
    return render_not_found if piece.blank?

    logger.info "is_obstructed? result: #{piece.is_obstructed?(new_x_pos, new_y_pos)}"
    logger.info "valid_move? results: #{piece.valid_move?(new_x_pos, new_y_pos)}"
    
    logger.info "game_full? result: #{@game.game_full?}"
    
    if !@game.game_full?
      flash[:alert] = "Waiting for another player to join..."
      redirect_to game_path(piece.game)
    elsif piece.valid_move?(new_x_pos, new_y_pos)
      if your_turn_your_piece?
        piece.move_to!(new_x_pos, new_y_pos)
        @game.update(turn: @turn + 1)
      elsif your_turn_not_your_piece?
        flash[:alert] = "Sorry, that's not your piece."
        redirect_to game_path(piece.game)        
      else
        flash[:alert] = "Sorry, it's not your turn."
        redirect_to game_path(piece.game)
      end
    else
      flash[:alert] = "Sorry your #{piece.name} can't move there."
      redirect_to game_path(piece.game)
    end
  end

  private

  def piece_params
    params.permit(:name, :x_pos, :y_pos, :color, :captured, :game_id, :id)
  end

  def current_piece
    Piece.find(params[:id])
  end

  def white_piece?
    current_piece.color == "White"
  end

  def black_piece?
    current_piece.color == "Black"
  end

  def white_piece_turn?
    @game.white_piece_turn?
  end

  def black_piece_turn?
    @game.black_piece_turn?
  end

  def white_player?
    current_user == current_piece.game.white_player
  end

  def black_player?
    current_user == current_piece.game.black_player
  end

  def white_move_white?
    white_piece_turn? && white_player? && white_piece? 
  end

  def black_move_black?
    black_piece_turn? && black_player? && black_piece?
  end

  def white_move_black?
    white_piece_turn? && white_player? && black_piece?
  end

  def black_move_white?
    black_piece_turn? && black_player? && white_piece?
  end

  def your_turn_your_piece?
    white_move_white? || black_move_black?
  end

  def your_turn_not_your_piece?
    white_move_black? || black_move_white?
  end

  def current_game_player?
    white_player? || black_player?
  end

  def require_game_player
    if !current_game_player?
      flash[:alert] = "Sorry, you are not part of this game."
      redirect_to game_path(current_piece.game)
    end
  end

end
