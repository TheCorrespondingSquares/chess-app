require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#is_obstructed?" do
    subject(:is_obstructed?) { piece_to_move.is_obstructed?(destination_x, destination_y) }

    let(:piece_to_move) { FactoryGirl.create(:piece, color: "Black", name: name_to_move, x_pos: 3, y_pos: 2, game_id: game.id) }

    describe "For Knight can't be obstructed" do
      let(:name_to_move) { "Knight" }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq(false) }
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

end