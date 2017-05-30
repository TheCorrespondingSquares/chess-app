class PiecesController < ApplicationController

	def show
		@piece = Piece.find(params[:id])
	end

  private

  def game_params
    params.require(:piece).permit(:name, :x_pos, :y_pos, :captured)
  end
end
