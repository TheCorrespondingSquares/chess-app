class PiecesController < ApplicationController
		
	def show
		render json: Piece.find(params[:id])
	end

	def update
		piece = Piece.find(params[:id])
		logger.info "Params:"
		logger.info "#{params}"

		@game = piece.game
		
		
		return render_not_found if piece.blank?

		piece.update_attributes(piece_params)
		
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
