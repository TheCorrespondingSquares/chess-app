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
<<<<<<< HEAD
=======
  	let!(:piece) { FactoryGirl.create(:piece, game_id: game.id, color: 'Black') }
  	let!(:piece2) { FactoryGirl.create(:piece, game_id: game.id, color: 'white') }
>>>>>>> 820340394b5f6df5e01dade9bcba323dcf683f51
  	
  	it 'should successfully show the page of the game' do
  		get :show, params: { id: game.id }
  		expect(response).to have_http_status(:success)
  	end

  	it 'should return the number and the correct piece' do
  		get :show, params: { id: game.id }
  		@pieces = game.pieces
<<<<<<< HEAD
  		expect(@pieces.count).to eq 32
=======
  		expect(@pieces.count).to eq 34
  		expect(@pieces.first.color).to eq('Black')
>>>>>>> 820340394b5f6df5e01dade9bcba323dcf683f51
  	end
  end	
end
