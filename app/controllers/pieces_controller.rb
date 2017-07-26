class PiecesController < ApplicationController
  before_action :require_game_player, only: [:update, :create, :destroy]

  def show
    render json: current_piece
  end

  def update
    piece = current_piece
    @new_x_pos = params[:x_pos].to_i
    @new_y_pos = params[:y_pos].to_i
    @starting_x = current_piece.x_pos
    @starting_y = current_piece.y_pos
    @game = piece.game
    @turn = @game.turn
    @piece_turn = piece.turn

    return render_not_found if piece.blank?

    logger.info "is_obstructed? result: #{piece.is_obstructed?(@new_x_pos, @new_y_pos)}"
    logger.info "valid_move? results: #{piece.valid_move?(@new_x_pos, @new_y_pos)}"
    
    logger.info "game_full? result: #{@game.game_full?}"

    move_if_possible
  end

  private

  def move_if_possible
    piece = current_piece
    if !@game.game_full?
      redirect_to game_path(piece.game)
    elsif piece.valid_move?(@new_x_pos, @new_y_pos)
      if your_turn_your_piece?
        if move_would_leave_your_king_in_check?        
          flash[:alert] = "Sorry, that move would leave your King in check."
          redirect_to game_path(piece.game)
        else
          piece.move_to!(@new_x_pos, @new_y_pos)
          promote_pawn_if_possible
          update_game_turn
          update_piece_turn
          Pusher.trigger('channel', 'trigger_refresh', { message: 'Piece Moved!' })    
        end
      elsif your_turn_not_your_piece?
        flash[:alert] = "Sorry, that's not your piece."
        redirect_to game_path(piece.game)        
      else
        flash[:alert] = "Sorry, it's not your turn."
        redirect_to game_path(piece.game)
      end
    else
      flash[:alert] = "Sorry, your #{piece.name} can't move there."
      redirect_to game_path(piece.game)
    end
  end

  def update_game_turn
    @game.update(turn: @turn + 1)
  end
  
  def update_piece_turn
    current_piece.update(turn: @piece_turn + 1)
  end

  def move_would_leave_your_king_in_check?
    current_piece.move_leaves_king_in_check?(@new_x_pos, @new_y_pos)
  end

  def your_king_is_in_check?
    @game.check?(current_piece.color)
  end

  def is_pawn?
    current_piece.name == "Pawn"
  end

  def pawn_can_promote?
    if is_pawn?
      current_piece.can_promote?(@new_y_pos)
    else
      false
    end
  end

  def promote_pawn(pawn)
    pawn.update_attributes(name: "Queen", icon: '&#9819;')
  end  

  def promote_pawn_if_possible
    if pawn_can_promote?
      promote_pawn(current_piece)
      flash[:notice] = "Your Pawn has been promoted to Queen. Long may she reign."
    end
  end  

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
