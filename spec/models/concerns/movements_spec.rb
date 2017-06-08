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

end  