require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#capture_piece!" do
    let(:piece_capturer) { FactoryGirl.create(:bishop, color: "Black", x_pos: 7, y_pos: 3, game_id: game.id) }
    let(:piece_target) { FactoryGirl.create(:pawn, color: captured_color, x_pos: target_x, y_pos: target_y, game_id: game.id) }
    let(:target_x) { 5 }
    let(:target_y) { 5 }
    
    context 'capture opposing piece' do
      let(:captured_color) { "White" }

      it ', remove opposing piece from board, and update piece position' do
        expect(piece_target.x_pos).to eq(target_x)
        expect(piece_target.y_pos).to eq(target_y)

        piece_capturer.capture_piece!(target_x, target_y)
        piece_target.reload

        expect(piece_target.x_pos).to eq(nil)
        expect(piece_target.y_pos).to eq(nil)
        expect(piece_target.captured).to eq(true)
      end
    end

    context 'cannot capture your own piece' do
      let(:captured_color) { "Black" }

      it ', target piece doesn\'t change' do
        expect(piece_target.x_pos).to eq(target_x)
        expect(piece_target.y_pos).to eq(target_y)

        piece_capturer.capture_piece!(target_x, target_y)
        piece_target.reload

        expect(piece_target.x_pos).to eq(target_x)
        expect(piece_target.y_pos).to eq(target_y)
        expect(piece_target.captured).to eq(false)
      end
    end     
  end    

  describe "#move_to!" do
    let(:piece_moving) { FactoryGirl.create(:queen, color: "Black", x_pos: 7, y_pos: 7, game_id: game.id) }
    let(:destination_x) { 6 }
    let(:destination_y) { 6 }

    context 'empty square' do
      it 'and update piece position' do
        piece_moving.move_to!(destination_x, destination_y)
        expect(piece_moving.x_pos).to eq(destination_x)
        expect(piece_moving.y_pos).to eq(destination_y)
      end
    end

    context 'move and capture' do
      let(:captured_piece) { FactoryGirl.create(:knight, color: "White", x_pos: 6, y_pos: 6, game_id: game.id) }

      it ', update positions of moving piece and captured piece' do
        expect(captured_piece.x_pos).to eq(6)
        expect(captured_piece.y_pos).to eq(6)

        piece_moving.move_to!(destination_x, destination_y)
        captured_piece.reload

        expect(captured_piece.x_pos).to eq(nil)
        expect(captured_piece.y_pos).to eq(nil)
        expect(captured_piece.captured).to eq(true)
        expect(piece_moving.x_pos).to eq(destination_x)
        expect(piece_moving.y_pos).to eq(destination_y)
      end
    end
  end
<<<<<<< HEAD
<<<<<<< HEAD

  describe "#pawn_valid_move?" do
    subject(:pawn_valid_move?) { pawn.pawn_valid_move?(destination_x, destination_y) }

    let!(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 1, game_id: game.id) }

    context 'for valid move' do
      context 'vertical first move' do
        let(:destination_x) { pawn.x_pos }
        let(:destination_y) { 3 }

        it { is_expected.to eq(true) }      
      end

      context 'vertical' do
        let(:destination_x) { pawn.x_pos }
        let(:destination_y) { 4 }

        it { is_expected.to eq(true) }
      end

      context 'diagonal' do
        let(:destination_x) { 1 }
        let(:destination_y) { 2 }

        it { is_expected.to eq(true) }   
      end
    end

    context 'for invalid move' do
      context '2 squares other than first move' do
        let(:destination_x) { 3 }
        let(:destination_y) { 4 }

        it { is_expected.to eq(true) }   
      end

      context 'diagonal without capture' do
        let(:destination_x) { 1 }
        let(:destination_y) { 2 }

        it { is_expected.to eq(true) }   
      end

      context 'backward vertical move' do
        let(:destination_x) { 3 }
        let(:destination_y) { 0 }

        it { is_expected.to eq(false) }   
      end
    end
  end

=======
  
>>>>>>> 7a85356aa05a1ac9297c8ed96f6a01e6e0746a74
end
