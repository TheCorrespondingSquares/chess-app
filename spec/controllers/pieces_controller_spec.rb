require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:white_player) { FactoryGirl.create(:user) }
  let(:black_player) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: white_player.id, black_player_id: black_player.id) }

  describe 'pieces#show action' do
    let(:rook) { FactoryGirl.create(:rook, color: "Black", x_pos: 7, y_pos: 7, game_id: game.id) }
    it 'should successfully show the page of the game' do
  		get :show, params: { game_id: game.id, id: rook.id }
  		expect(response).to have_http_status(:success)
  		expect(rook.color).to eq('Black')
    end
  end

  describe 'pieces#update action' do
    
    context 'When only one player has joined' do
      let(:game_not_full) { FactoryGirl.create(:game, white_player_id: white_player.id, black_player_id: nil) }
      let(:player1_pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 5, y_pos: 1, game_id: game_not_full.id) }

    	it 'should not allow move if only one player has joined' do
    	  patch :update, params: {game_id: game_not_full.id, id: player1_pawn.id, x_pos: 5, y_pos: 2}

    	  expect(flash[:alert]).to match("Waiting for another player to join...")
        expect(player1_pawn.x_pos).to eq(5)
        expect(player1_pawn.y_pos).to eq(1)
    	end
    end

    context 'When both players have joined' do
      let!(:white_pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 4, y_pos: 1, game_id: game.id) }
      let!(:black_pawn) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 6, game_id: game.id) }
      before(:each) { game.update_attributes(turn: 0) }

    	it 'should not allow Black piece to move first' do
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 4 }
        black_pawn.reload

        expect(flash[:alert]).to match("Sorry, it's not your turn.")
        expect(black_pawn.x_pos).to eq(4)
        expect(black_pawn.y_pos).to eq(6)
        expect(game.turn).to eq(0)
    	end

      it 'should allow White piece to move first' do
        patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 3 }
        white_pawn.reload
        game.reload

        expect(white_pawn.x_pos).to eq 4
        expect(white_pawn.y_pos).to eq 3
        expect(game.turn).to eq(1)
      end

      it 'should allow Black piece to move second' do
        game.update_attributes(turn: 1)
        game.reload
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 4 }
        black_pawn.reload
        game.reload

        expect(black_pawn.x_pos).to eq 4
        expect(black_pawn.y_pos).to eq 4
        expect(game.turn).to eq(2)
      end

      it 'should not allow White piece to move on Black piece\'s turn' do
        game.update_attributes(turn: 19)
        game.reload
        patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 2 }
        white_pawn.reload
        game.reload

        expect(white_pawn.x_pos).to eq 4
        expect(white_pawn.y_pos).to eq 1
        expect(game.turn).to eq(19)        
      end

      it 'should not allow Black piece to move on White piece\'s turn' do
        game.update_attributes(turn: 34)
        game.reload
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 5 }
        black_pawn.reload
        game.reload

        expect(black_pawn.x_pos).to eq 4
        expect(black_pawn.y_pos).to eq 6
        expect(game.turn).to eq(34)
      end
    end
  end	
end
