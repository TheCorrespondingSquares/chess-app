class DashboardsController < ApplicationController
  def index
    @available_games = Game.available
    @games = @available_games.where.not(black_player_id: current_user).or(@available_games.where.not(white_player_id: current_user))
  end
end
