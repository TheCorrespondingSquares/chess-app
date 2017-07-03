class PiecesController < ApplicationController
		
	def show
		render json: Piece.find(params[:id])
	end

	def update
		piece = Piece.find(params[:id])
		new_x_pos = params[:x_pos].to_i
		new_y_pos = params[:y_pos].to_i

		logger.info "Params:
		Orig x_pos: #{piece.x_pos.inspect}, Orig y_pos: #{piece.y_pos.inspect},
		Dest x_pos: #{new_x_pos.inspect}, Dest y_pos: #{params[:y_pos].to_i.inspect}"

		@game = piece.game
		
		
		return render_not_found if piece.blank?

		logger.info "is_obstructed? result: #{piece.is_obstructed?(new_x_pos, new_y_pos)}"
		logger.info "valid_move? results: #{piece.valid_move?(new_x_pos, new_y_pos)}"
		
		if piece.valid_move?(new_x_pos, new_y_pos)
    	  piece.move_to!(new_x_pos, new_y_pos)
    	  	if can_promote?(y_pos)
				promote_pawn(name)
			end
		else
			flash[:alert] = "Sorry your #{piece.name} can't move there."
			redirect_to game_path(piece.game)
		end

	end

  private

  def piece_params
    params.permit(:name, :x_pos, :y_pos, :captured, :game_id, :id)
  end
end
