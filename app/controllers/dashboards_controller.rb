class DashboardsController < ApplicationController
<<<<<<< HEAD
  def index
    @available_games = Game.available
    @games = @available_games.where.not(black_player_id: current_user).or(@available_games.where.not(white_player_id: current_user))
=======
  before_action :authenticate_user!

  def index
    @games = Game.all
    @available_games = Game.available 
    if user_signed_in?
      @my_games = Game.where('white_player_id = ? or black_player_id = ?', current_user.id, current_user.id).order('updated_at DESC')
    end
>>>>>>> c4e8379fa23c67baed3d173f2f1a977ba399adb1
  end
end
