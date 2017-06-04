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
  	let!(:game) { FactoryGirl.create(:game, white_player_id: user.id) }
  	let!(:piece) { FactoryGirl.create(:piece, game_id: game.id, color: 'Black') }
  	let!(:piece2) { FactoryGirl.create(:piece, game_id: game.id, color: 'white') }
  	
  	it 'should successfully show the page of the game' do
  		get :show, params: { id: game.id }
  		expect(response).to have_http_status(:success)
  	end

  	it 'should return the number and the correct piece' do
  		get :show, params: { id: game.id }
  		@pieces = game.pieces
  		expect(@pieces.count).to eq 34
  		expect(@pieces.first.color).to eq('White')
  	end
  end	
end
