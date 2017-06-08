require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#bishop_valid_move?" do
    subject(:bishop_valid_move?) { bishop.bishop_valid_move?(destination_x, destination_y) }

    let(:bishop) { FactoryGirl.create(:bishop, color: "White", x_pos: 3, y_pos: 0, game_id: game.id) }

    context 'for valid move' do
      context 'diagonal' do
        let(:destination_x) { 1 }
        let(:destination_y) { 2 }

        it { is_expected.to eq(true) }   
      end
    end

    context 'for invalid move' do
      let(:destination_x) { 4 }
      let(:destination_y) { 5 }

      it { is_expected.to eq(false) }
    end
  end

end  