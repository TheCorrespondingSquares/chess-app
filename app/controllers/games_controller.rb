class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @available_games = Game.available
    @games = @available_games.where.not(black_player: current_user).or(@available_games.where.not(white_player: current_user))
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.populate_board!
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find(params[:id])
    @pieces = @game.pieces
  end

  private

  def game_params
    params.require(:game).permit(:name, :white_player_id, :black_player_id)
  end
end
