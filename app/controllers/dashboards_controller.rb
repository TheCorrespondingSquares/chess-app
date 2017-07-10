class DashboardsController < ApplicationController
  def index
    @games = Game.all
    @available_games = Game.available 
    @my_games = Game.where('white_player_id = ? or black_player_id = ?', current_user.id, current_user.id).order('updated_at DESC')
  end
end
