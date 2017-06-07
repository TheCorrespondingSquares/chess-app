require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "direction" do
    let(:rook) { FactoryGirl.create(:rook, color: "Black", x_pos: 3, y_pos: 3, game_id: game.id) }
    
    describe "#right_or_left" do
      subject(:right_or_left) { rook.right_or_left(destination_x) }

      context 'for horizontal path' do
        context 'when moving right' do
          let(:destination_x) { 5 }

          it { is_expected.to eq(1) }
        end

        context 'when moving left' do
          let(:destination_x) { 2 }

          it { is_expected.to eq(-1) }
        end
      end
    end

    describe "#up_or_down" do
      subject(:up_or_down) { rook.up_or_down(destination_y) }

      context 'for vertical path' do
        context 'when moving up' do
          let(:destination_y) { 7 }

          it { is_expected.to eq(1) }
        end

        context 'when moving down' do
          let(:destination_y) { 0 }

          it { is_expected.to eq(-1) }
        end
      end
    end
  end

  describe "#is_on_square?" do
    subject(:is_on_square?) { pawn.is_on_square?(x, y) }

    let(:pawn) { FactoryGirl.create(:pawn, color: "Black", x_pos: 1, y_pos: 1, game_id: game.id) }

    context 'for the coordinates' do
      context 'when there is an existing piece' do
        let(:x) { 1 }
        let(:y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when there is no existing piece' do
        let(:x) { 5 }
        let(:y) { 5 }

        it { is_expected.to eq(false) }
      end
    end
  end

  describe "#is_obstructed?" do
    subject(:is_obstructed?) { piece_to_move.is_obstructed?(destination_x, destination_y) }

    let(:piece_to_move) { FactoryGirl.create(:piece, color: "Black", name: name_to_move, x_pos: 3, y_pos: 2, game_id: game.id) }

    describe "For Knight can't be obstructed" do
      let(:name_to_move) { "Knight" }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq("invalid") }
    end

    describe 'Any obstructions' do      
      before(:each) { FactoryGirl.create(:rook, color: "White", x_pos: x_obstructs, y_pos: y_obstructs, game_id: game.id) }
      let(:name_to_move) { "Queen" }

      context 'for the horizontal direction' do
        let(:destination_x) { 6 }
        let(:destination_y) { 2 }

        context 'when there is an obstruction' do
          let(:x_obstructs) { 5 }
          let(:y_obstructs) { 2 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_obstructs) { 6 }
          let(:y_obstructs) { 2 }

          it { is_expected.to eq(false) }
        end
      end

      context 'for the vertical direction' do
        let(:destination_x) { 3 }
        let(:destination_y) { 6 }

        context 'when there is an obstruction' do
          let(:x_obstructs) { 3 }
          let(:y_obstructs) { 3 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_obstructs) { 0 }
          let(:y_obstructs) { 0 }

          it { is_expected.to eq(false) }
        end
      end

      context 'for the diagonal direction' do
          let(:destination_x) { 7 }
          let(:destination_y) { 6 }        

        context 'when there is an obstruction' do
          let(:x_obstructs) { 5 }
          let(:y_obstructs) { 4 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_obstructs) { 7 }
          let(:y_obstructs) { 6 }

          it { is_expected.to eq(false) }
        end
      end
    end
  end

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

  describe "#king_valid_move?" do
    subject(:king_valid_move?) { king.king_valid_move?(destination_x, destination_y) }

    let(:king) { FactoryGirl.create(:king, x_pos: 4, y_pos: 0, game_id: game.id) }

    context 'for horizontal move' do
      let(:destination_y) { king.y_pos }

      context 'when valid' do
        let(:destination_x) { 3 }
        
        it { is_expected.to eq(true) }
      end

      context 'when not valid' do
        let(:destination_x) { 6 }

        it { is_expected.to eq(false) }
      end
    end

    context 'for vertical move' do
      let(:destination_x) { king.x_pos }

      context 'when valid' do
        let(:destination_y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when not valid' do
        let(:destination_y) { 5 }

        it { is_expected.to eq(false) }
      end
    end

    context 'for diagonal move' do
      context 'when valid' do
        let(:destination_x) { 3 }
        let(:destination_y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when not valid' do
        let(:destination_x) { 1 }
        let(:destination_y) { 3 }

        it { is_expected.to eq(false) }
      end
    end
  end
end
