require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
	let!(:user) { FactoryGirl.create(:user) }
  let!(:game) { FactoryGirl.create(:game, white_player_id: user.id) }
  let!(:piece) { FactoryGirl.create(:piece, game_id: game.id, color: 'black') }

	describe 'pieces#show action' do
  	
  	it 'should successfully show the page of the game' do
  		get :show, params: { game_id: game.id, id: piece.id }
  		expect(response).to have_http_status(:success)
  		expect(piece.color).to eq('black')
  	end
  	
	end
end
