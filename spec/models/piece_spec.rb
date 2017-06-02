require 'rails_helper'

RSpec.describe Piece, type: :model do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
  let(:piece) { FactoryGirl.create(:piece, x_pos: 3, y_pos: 3, game_id: game.id) }

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

    let!(:piece) { FactoryGirl.create(:piece, x_pos: 1, y_pos: 1, game_id: game.id) }

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
    subject(:is_obstructed?) { piece_to_move.is_obstructed?(destination_x, destination_y) }

    let!(:piece_to_move) { FactoryGirl.create(:piece, name: name_to_move, x_pos: 3, y_pos: 2, game_id: game.id) }

    describe "For Knight can't be obstructed" do
      let(:name_to_move) { "Knight" }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq("invalid") }
    end

    describe 'Any obstructions' do      
      let!(:piece_obstructs) { FactoryGirl.create(:piece, name: "Rook", x_pos: x_obstructs, y_pos: y_obstructs, game_id: game.id) }
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

  describe "#move_to!" do
    subject(:move_to!) { piece_moving.move_to!(destination_x, destination_y) }

    let!(:piece_moving) { FactoryGirl.create(:piece, name: "Queen", x_pos: start_x, y_pos: start_y, game_id: game.id) }
    let!(:piece_opponent) { FactoryGirl.create(:piece, name: "Rook", x_pos: 5, y_pos: 5, game_id: game.id) }
    let(:destination_x) { 6 }
    let(:destination_y) { 6 }

    context "can't move if obstructed" do
      let(:start_x) { 3 }
      let(:start_y) { 3 }

      it { is_expected.to eq(nil) }
    end

    context 'can move unobstructed' do      
      let(:start_x) { 7 }
      let(:start_y) { 7 }

      context 'to an empty square' do
        it 'and update piece position' do
          expect(piece_moving.x_pos).to eq(destination_x)
          expect(piece_moving.y_pos).to eq(destination_y)
        end
      end

      context 'to capture a piece' do
        let(:destination_x) { 5 }
        let(:destination_y) { 5 }

        it "and remove captured piece from board / update piece position" do
          expect(piece_opponent.x_pos).to eq(nil)
          expect(piece_opponent.y_pos).to eq(nil)
          expect(piece_moving.x_pos).to eq(destination_x)
          expect(piece_moving.y_pos).to eq(destination_y)
        end
      end      
    end
  end  
end
