class PiecesController < ApplicationController
		
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
		elsif piece.valid_move?(new_x_pos, new_y_pos)
	  	if white_piece_turn? || black_piece_turn?
	  		piece.move_to!(new_x_pos, new_y_pos)
				@game.update(turn: @turn + 1)
	  	else
	  		flash[:alert] = "Sorry, it's not your turn."
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

  def white_piece_turn?
  	@game.white_piece_turn? && current_piece.color == "White"
  end

  def black_piece_turn?
  	@game.black_piece_turn? && current_piece.color == "Black"
  end

end
