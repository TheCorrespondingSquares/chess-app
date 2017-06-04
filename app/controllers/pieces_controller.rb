class PiecesController < ApplicationController

	def show
		@piece = Piece.find(params[:id])
		@game = @piece.game
	end

	def edit
		render json: {foo: 'bar'}
	end

	def update
		@piece = Piece.find(params[:id])
		@game = @piece.game
		
		return render_not_found if @piece.blank?

		@piece.update_attributes(piece_params)

		if @piece.valid?
			redirect_to game_path(@game)
		else
			return render :edit, status: :unprocessable_entity
		end
	end

  private

  def piece_params
    params.permit(:name, :x_pos, :y_pos, :captured, :game_id)
  end
end
