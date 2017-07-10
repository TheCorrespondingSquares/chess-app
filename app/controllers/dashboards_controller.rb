class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @games = Game.all
    @available_games = Game.available 
    if user_signed_in?
      @my_games = Game.where('white_player_id = ? or black_player_id = ?', current_user.id, current_user.id).order('updated_at DESC')
    end
  end
end
