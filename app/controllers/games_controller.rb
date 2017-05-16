class GamesController < ApplicationController
    
    def index
        @games = Game.all
    end
    
    def new
    end
    
    def create
        @game = Game.create(game_params)
    end
    
    def show
        @game = Game.find(params[:id])
    end
    
private 
    
    def game_params
        params.require(:game).permit(:name)
    end
end
