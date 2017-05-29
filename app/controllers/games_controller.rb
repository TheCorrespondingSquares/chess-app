class GamesController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create]

  def index
    @games = Game.all
    @games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    @user = @game.user_id
  end

  private

  def game_params
    params.require(:game).permit(:name, :user_id)
  end
end
