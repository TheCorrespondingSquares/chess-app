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
    
    context 'When a piece making a check' do
      before(:each) { game.pieces.destroy_all } 
      let!(:white_bishop) { FactoryGirl.create(:bishop, color: "White", x_pos: 5, y_pos: 3, game_id: game.id) }
      let!(:black_king) { FactoryGirl.create(:king, color: "Black", x_pos: 7, y_pos: 7, game_id: game.id) }
      let!(:white_king) { FactoryGirl.create(:king, color: "White", x_pos: 2, y_pos: 0, game_id: game.id) }
      before(:each) { game.update_attributes(turn: 0) }
      before(:each) { sign_out white_player }
      before(:each) { sign_out black_player }

      it ' should raise an alert' do
        sign_in white_player
        game.reload
        patch :update, params: { game_id: game.id, id: white_bishop.id, x_pos: 4, y_pos: 4 }
        white_bishop.reload
        game.reload

        expect(white_bishop.x_pos).to eq 4
        expect(white_bishop.y_pos).to eq 4
        expect(flash[:notice]).to match("Check!")
      end
    end

    context 'When there is a check condition' do
      before(:each) { game.pieces.destroy_all } 
      let!(:white_bishop) { FactoryGirl.create(:bishop, color: "White", x_pos: 4, y_pos: 4, game_id: game.id) }
      let!(:black_bishop) { FactoryGirl.create(:bishop, color: "Black", x_pos: 6, y_pos: 4, game_id: game.id) }
      let!(:black_king) { FactoryGirl.create(:king, color: "Black", x_pos: 7, y_pos: 7, game_id: game.id) }
      let!(:white_king) { FactoryGirl.create(:king, color: "White", x_pos: 4, y_pos: 0, game_id: game.id) }
      before(:each) { game.update_attributes(turn: 0) }
      before(:each) { sign_out white_player }
      before(:each) { sign_out black_player }

      it ' should prohibit the next move because check is not cleared' do
        sign_in black_player
        game.update_attributes(turn: 1)
        game.reload
        patch :update, params: { game_id: game.id, id: black_bishop.id, x_pos: 7, y_pos: 3 }
        black_bishop.reload
        game.reload

        expect(black_bishop.x_pos).to eq 6
        expect(black_bishop.y_pos).to eq 4
        expect(flash[:notice]).to match("Your king is still in check.")
        expect(game.black_piece_turn?).to eq(true)
      end

      it ' should allow the next move because check is cleared' do
        sign_in black_player
        game.update_attributes(turn: 1)
        game.reload
        patch :update, params: { game_id: game.id, id: black_bishop.id, x_pos: 5, y_pos: 5 }
        black_bishop.reload
        game.reload

        expect(black_bishop.x_pos).to eq 5
        expect(black_bishop.y_pos).to eq 5
        expect(game.white_piece_turn?).to eq(true)
      end
    end

    context 'When only one player has joined' do
      let(:game_not_full) { FactoryGirl.create(:game, white_player_id: white_player.id, black_player_id: nil) }
      let(:player1_pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 5, y_pos: 1, game_id: game_not_full.id) }

      it 'should not allow move if only one player has joined' do
        sign_in white_player
        patch :update, params: {game_id: game_not_full.id, id: player1_pawn.id, x_pos: 5, y_pos: 2}

        # expect(flash[:alert]).to match("Waiting for another player to join...")
        expect(player1_pawn.x_pos).to eq(5)
        expect(player1_pawn.y_pos).to eq(1)
      end
    end

    context 'When both players have joined' do
      let!(:white_pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 4, y_pos: 1, game_id: game.id) }
      let!(:black_pawn) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 6, game_id: game.id) }
      before(:each) { game.update_attributes(turn: 0) }
      before(:each) { sign_out white_player }
      before(:each) { sign_out black_player }

      it 'should not allow Black piece/player to move first' do
        sign_in black_player
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 4 }
        black_pawn.reload

        expect(flash[:alert]).to match("Sorry, it's not your turn.")
        expect(black_pawn.x_pos).to eq(4)
        expect(black_pawn.y_pos).to eq(6)
        expect(game.turn).to eq(0)
      end

      it 'should allow White piece/player to move first' do
        sign_in white_player
        game.update_attributes(turn: 0)
        game.reload
        patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 3 }
        white_pawn.reload
        game.reload

        expect(white_pawn.x_pos).to eq 4
        expect(white_pawn.y_pos).to eq 3
        expect(game.turn).to eq(1)
      end

      it 'should allow Black piece/player to move second' do
        sign_in black_player
        game.update_attributes(turn: 1)
        game.reload
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 4 }
        black_pawn.reload
        game.reload

        expect(black_pawn.x_pos).to eq 4
        expect(black_pawn.y_pos).to eq 4
        expect(game.turn).to eq(2)
      end

      it 'should not allow White piece/player to move on Black piece/player\'s turn' do
        sign_in white_player
        game.update_attributes(turn: 19)
        game.reload
        patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 2 }
        white_pawn.reload
        game.reload

        expect(flash[:alert]).to match("Sorry, it's not your turn.")
        expect(white_pawn.x_pos).to eq 4
        expect(white_pawn.y_pos).to eq 1
        expect(game.turn).to eq(19)        
      end

      it 'should not allow Black piece/player to move on White piece/player\'s turn' do
        sign_in black_player
        game.update_attributes(turn: 34)
        game.reload
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 5 }
        black_pawn.reload
        game.reload

        expect(flash[:alert]).to match("Sorry, it's not your turn.")
        expect(black_pawn.x_pos).to eq 4
        expect(black_pawn.y_pos).to eq 6
        expect(game.turn).to eq(34)
      end

      it 'should not allow White player to move Black piece' do
        sign_in white_player
        game.update_attributes(turn: 4)
        game.reload
        patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 5 }
        black_pawn.reload
        game.reload

        expect(flash[:alert]).to match("Sorry, that's not your piece.")
        expect(black_pawn.x_pos).to eq 4
        expect(black_pawn.y_pos).to eq 6
        expect(game.turn).to eq(4)
      end

      it 'should not allow Black player to move White piece' do
        sign_in black_player
        game.update_attributes(turn: 11)
        game.reload
        patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 2 }
        white_pawn.reload
        game.reload

        expect(flash[:alert]).to match("Sorry, that's not your piece.")
        expect(white_pawn.x_pos).to eq 4
        expect(white_pawn.y_pos).to eq 1
        expect(game.turn).to eq(11)
      end

      context 'if a user who is not in the game tries to move a piece' do
        let(:third_user) { FactoryGirl.create(:user) }

        it 'should not let non-game user move White piece' do
          sign_in third_user
          game.update_attributes(turn: 16)
          game.reload
          patch :update, params: { game_id: game.id, id: white_pawn.id, x_pos: 4, y_pos: 2 }
          white_pawn.reload
          game.reload          

          expect(flash[:alert]).to match("Sorry, you are not part of this game.")
          expect(white_pawn.x_pos).to eq 4
          expect(white_pawn.y_pos).to eq 1
          expect(game.turn).to eq(16)              
        end

        it 'should not let non-game user move Black piece' do
          sign_in third_user
          game.update_attributes(turn: 23)
          game.reload
          patch :update, params: { game_id: game.id, id: black_pawn.id, x_pos: 4, y_pos: 5 }
          black_pawn.reload
          game.reload

          expect(flash[:alert]).to match("Sorry, you are not part of this game.")
          expect(black_pawn.x_pos).to eq 4
          expect(black_pawn.y_pos).to eq 6
          expect(game.turn).to eq(23)          
        end
      end

    end
  end 
end
