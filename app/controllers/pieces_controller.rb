class PiecesController < ApplicationController
		
	def show
		render json: Piece.find(params[:id])
	end

	def update
		piece = Piece.find(params[:id])
		logger.info "Params:
		Orig x_pos: #{piece.x_pos}, Orig y_pos: #{piece.y_pos},
		Dest x_pos: #{params[:x_pos]}, Dest y_pos: #{params[:y_pos]}"
		

		@game = piece.game
		
		
		return render_not_found if piece.blank?

		# piece.update_attributes(piece_params)
		piece.move_to!(params[:x_pos], params[:y_pos])

		if piece.valid?
			return render json: piece
		else
			return render :edit, status: :unprocessable_entity
		end
	end

  private

  def piece_params
    params.permit(:name, :x_pos, :y_pos, :captured, :game_id, :id)
  end
end
