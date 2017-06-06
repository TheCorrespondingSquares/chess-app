require 'rails_helper'

RSpec.describe Piece, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:game) { FactoryGirl.create(:game, black_player_id: user.id)}

  describe "direction" do
    let!(:rook) { FactoryGirl.create(:rook, color: "black", x_pos: 3, y_pos: 3, game_id: game.id) }
    
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

    let!(:pawn) { FactoryGirl.create(:pawn, color: "black", x_pos: 1, y_pos: 1, game_id: game.id) }

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

  # This can be sub-divided to de clutter this test-suite.
  describe "#is_obstructed?" do
    subject(:is_obstructed?) { piece_to_move.is_obstructed?(destination_x, destination_y) }

    let!(:piece_to_move) { FactoryGirl.create(:piece, color: "black", name: name_to_move, x_pos: 3, y_pos: 2, game_id: game.id) }

    describe "For Knight can't be obstructed" do
      let(:name_to_move) { "Knight" }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq("invalid") }
    end

    describe 'Any obstructions' do      
      let!(:piece_obstructs) { FactoryGirl.create(:rook, color: "white", x_pos: x_obstructs, y_pos: y_obstructs, game_id: game.id) }
      let!(:name_to_move) { "Queen" }

      context 'for the horizontal direction' do
        let!(:destination_x) { 6 }
        let!(:destination_y) { 2 }

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
        let!(:destination_x) { 3 }
        let!(:destination_y) { 6 }

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
          let!(:destination_x) { 7 }
          let!(:destination_y) { 6 }        

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

  describe "#king_valid_move?" do
    subject(:king_valid_move?) { king.king_valid_move?(destination_x, destination_y) }

    let!(:king) { FactoryGirl.create(:king, x_pos: 4, y_pos: 0, game_id: game.id) }

    context 'for horizontal move' do
      let!(:destination_y) { king.y_pos }

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
      let!(:destination_x) { king.x_pos }

      context 'when valid' do
        let(:destination_y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when not valid' do
        let(:destination_y) { 5 }

        it { is_expected.to eq(false) }
      end
    end

    context 'for diagonal movement' do
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

  describe "#queen_valid_move?" do
    subject(:queen_valid_move?) { queen.queen_valid_move?(destination_x, destination_y) }

    let!(:queen) { FactoryGirl.create(:queen, x_pos: 4, y_pos: 0, game_id: game.id) }

    context 'for horizontal move' do
      let!(:destination_y) { queen.y_pos }

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
      let!(:destination_x) { queen.x_pos }

      context 'when valid' do
        let(:destination_y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when not valid' do
        let(:destination_y) { 5 }

        it { is_expected.to eq(false) }
      end
    end

    context 'for diagonal movement' do
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
