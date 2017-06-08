require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#is_on_square?" do
    subject(:is_on_square?) { pawn.is_on_square?(x, y) }

    let(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 1, y_pos: 1, game_id: game.id) }

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

end  