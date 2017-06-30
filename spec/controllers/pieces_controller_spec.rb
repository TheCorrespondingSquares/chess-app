require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) {FactoryGirl.create(:user) }
  # This game has two players
  let!(:game) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id, turn: 0)}
  # This game has one player
  let!(:game2) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: nil,  turn: 0)}
  # These piece belong to game1 w/two players
  let(:piece) { FactoryGirl.create(:piece, game_id: game.id, color: 'White', name: "Pawn", x_pos: 7, y_pos: 1) }
  let(:piece2) {FactoryGirl.create(:piece, game_id: game.id, color: 'Black', name: "Pawn", x_pos: 0, y_pos: 6) }
  # This piece belongs to game2 w/one player and is white
  let(:piece3) {FactoryGirl.create(:piece, game_id: game2.id, color: "White", x_pos: 7, y_pos: 1)}

  describe 'pieces#show action' do
    it 'should successfully show the page of the game' do
  		get :show, params: { game_id: game.id, id: piece.id }
  		expect(response).to have_http_status(:success)
  		expect(piece.color).to eq('White')
    end
  end

  describe 'pieces#update action' do
  	it 'should update the position of the piece to a new position' do
  		patch :update, params: { game_id: game.id, id: piece.id, x_pos: 7, y_pos: 2 }
  		piece.reload
  		expect(piece.x_pos).to eq 7
  		expect(piece.y_pos).to eq 2
  	end
  	
  	it 'should not move if only one player present' do
  	  patch :update, params: {game_id: game2.id, id: piece.id, x_pos: 7, y_pos: 2}
  	  expect(flash[:alert]).to match("Waiting for another player to join!")
  	end

  	it 'prompt when black piece attempts to move first' do
  		patch :update, params: { game_id: game.id, id: piece2.id, x_pos: 0, y_pos: 5 }
  		 expect(flash[:alert]).to match("White Moves First!")
  	end
  end	
end
