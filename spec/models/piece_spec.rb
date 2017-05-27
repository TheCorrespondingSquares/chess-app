require 'rails_helper'

RSpec.describe Piece, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:game) { FactoryGirl.create(:game, user_id: user.id)}
  let!(:piece) { FactoryGirl.create(:piece, x_pos: 3, y_pos: 3, user_id: user.id, game_id: game.id) }

  describe "#right_or_left" do
    subject(:right_or_left) { piece.right_or_left(destination_x) }

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
    subject(:up_or_down) { piece.up_or_down(destination_y) }

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

  describe "#is_on_square?" do
    subject(:is_on_square?) { piece.is_on_square?(x, y) }

    let!(:piece) { FactoryGirl.create(:piece, x_pos: 1, y_pos: 1, user_id: user.id, game_id: game.id) }

    context 'for the coordinates' do
      context 'when there is an existing piece' do
        let(:x) { 1 }
        let(:y) { 1 }

        it { is_expected.to eq(true) }
      end

      context 'when there is no existing piece' do
        let(:x) { 0 }
        let(:y) { 0 }

        it { is_expected.to eq(false) }
      end
    end
  end

  # This can be sub-divided to de clutter this test-suite.
  describe "#is_obstructed?" do
    subject(:is_obstructed?) { piece_move.is_obstructed?(destination_x, destination_y) }

    let!(:piece_move) { FactoryGirl.create(:piece, name: name, x_pos: x_start, y_pos: y_start, user_id: user.id, game_id: game.id) }

    describe "For Knight can't be obstructed" do
      let!(:name) { "Knight" }
      let(:x_start) { 3 }
      let(:y_start) { 2 }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq("invalid") }
    end

    describe 'Any obstructions' do
      let!(:name) { "Queen" }
      let!(:piece_obstruct) { FactoryGirl.create(:piece, name: name_obstruct, x_pos: x_obstruct, y_pos: y_obstruct, user_id: user.id, game_id: game.id) }
      let(:destination_x) { 0 }

      context 'for the horizontal direction' do
        context 'when there is an obstruction' do
          let(:x_start) { 3 }
          let(:y_start) { 3 }
          let(:destination_y) { 3 }

          let(:name_obstruct) { "Bishop" }
          let(:x_obstruct) { 1 }
          let(:y_obstruct) { 3 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_start) { 2 }
          let(:y_start) { 5 }
          let(:destination_x) { 6 }
          let(:destination_y) { 5 }

          let(:name_obstruct) { "Rook" }
          let(:x_obstruct) { 6 }
          let(:y_obstruct) { 5 }

          it { is_expected.to eq(false) }
        end
      end

      context 'for the vertical direction' do
        context 'when there is an obstruction' do
          let(:x_start) { 5 }
          let(:y_start) { 5 }
          let(:destination_x) { 5 }
          let(:destination_y) { 1 }

          let(:name_obstruct) { "Pawn" }
          let(:x_obstruct) { 5 }
          let(:y_obstruct) { 2 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_start) { 7 }
          let(:y_start) { 1 }
          let(:destination_x) { 7 }
          let(:destination_y) { 6 }

          let(:name_obstruct) { "Pawn" }
          let(:x_obstruct) { 7 }
          let(:y_obstruct) { 6 }

          it { is_expected.to eq(false) }
        end
      end

      context 'for the diagonal direction' do
        context 'when there is an obstruction' do
          let(:x_start) { 4 }
          let(:y_start) { 4 }
          let(:destination_x) { 0 }
          let(:destination_y) { 0 }

          let(:name_obstruct) { "Knight" }
          let(:x_obstruct) { 2 }
          let(:y_obstruct) { 2 }

          it { is_expected.to eq(true) }
        end

        context 'when there is no obstruction' do
          let(:x_start) { 2 }
          let(:y_start) { 5 }
          let(:destination_x) { 6 }
          let(:destination_y) { 1 }

          let(:name_obstruct) { "Bishop" }
          let(:x_obstruct) { 6 }
          let(:y_obstruct) { 1 }

          it { is_expected.to eq(false) }
        end
      end
    end
  end
end
