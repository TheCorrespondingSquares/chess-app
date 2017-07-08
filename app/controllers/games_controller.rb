class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @available_games = Game.available
    @games = @available_games.where.not(black_player_id: current_user).or(@available_games.where.not(white_player_id: current_user))
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
    @white_player = User.find(@game.white_player_id)
    if @game.black_player_id == nil
      flash[:notice] = "Waiting for another player to join..."
    else
       @black_player = User.find(@game.black_player_id)
    end
    @pieces = @game.pieces
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(join_params)

    # Pusher Test
    Pusher.trigger('channel', 'trigger_refresh', {
      message: 'Joined Game'
    })

    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name, :user_id, :white_player_id, :black_player_id, :turn)
  end

  def join_params
    params.permit(:black_player_id)
  end
end
