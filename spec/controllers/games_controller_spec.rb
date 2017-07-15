require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#index action' do
    it 'should successfully show the page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#show action' do
  	let!(:user) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
  	let!(:game) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id) }
  	
  	it 'should successfully show the page of the game' do
  		get :show, params: { id: game.id }
  		expect(response).to have_http_status(:success)
  	end

  	it 'should return the number and the correct piece' do
  		get :show, params: { id: game.id }
  		@pieces = game.pieces

  		expect(@pieces.count).to eq 32
  	end

    it 'should update the result the winner is White and notify the game is over' do
      game.pieces.destroy_all
      game.pieces.create(name: "King", color: "White", x_pos: 7, y_pos: 7)
      game.pieces.create(name: "King", color: "Black", x_pos: 7, y_pos: 4)
      game.pieces.create(name: "Bishop", color: "Black", x_pos: 4, y_pos: 4)
      game.pieces.create(name: "Bishop", color: "White", x_pos: 6, y_pos: 7)
      game.pieces.create(name: "Bishop", color: "White", x_pos: 7, y_pos: 6)
      get :show, params: { id: game.id }
      game.reload

      expect(game.result).to eq ("Winner: #{game.white_player_id}")
    end

    it 'should update the result the winner is Black and notify the game is over' do
      game.pieces.destroy_all
      game.pieces.create(name: "King", color: "Black", x_pos: 0, y_pos: 0)
      game.pieces.create(name: "Bishop", color: "White", x_pos: 4, y_pos: 4)
      game.pieces.create(name: "Bishop", color: "Black", x_pos: 0, y_pos: 1)
      game.pieces.create(name: "Bishop", color: "Black", x_pos: 1, y_pos: 0)
      game.pieces.create(name: "King", color: "White", x_pos: 7, y_pos: 4)
      get :show, params: { id: game.id }
      game.reload

      expect(game.result).to eq ("Winner: #{game.black_player_id}")
    end
  end	
end
