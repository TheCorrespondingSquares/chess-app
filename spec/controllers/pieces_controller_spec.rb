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

  describe 'pieces#update action' do

  	it 'should update the position of the piece to a new position' do
  		patch :update, params: { game_id: game.id, id: piece.id, x_pos: 7, y_pos: 6 }
  		expect(response).to redirect_to game_path(game)
  		piece.reload
  		expect(piece.x_pos).to eq 7
  		expect(piece.y_pos).to eq 6
  	end

  	it 'should render 404 if the piece cannot be found' do
  		# user = FactoryGirl.create(:user)
  		# game = FactoryGirl.create(:game, :white_player_id: user.id)
  		# piece = FactoryGirl.create()

  		# patch :update, params: { game_id: game.id, id: 'FAKE', x_pos: 7, y_pos: 6 }
  		# expect(response).to have_http_status(:not_found)
  	end
  end	
end
