require 'rails_helper'

RSpec.describe Knight, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#knight_valid_move?" do
    subject(:knight_valid_move?) { knight.knight_valid_move?(to_x, to_y) }
    
    let(:knight) {FactoryGirl.create(:knight, x_pos: 2, y_pos: 0, color: 'White', game_id: game.id)}
    
    context 'for valid move' do
      context '"tall"' do
        let(:to_x) { 3 }
        let(:to_y) { 2 }
        
        it { is_expected.to eq(true) }
      end

      context '"wide"' do
        let(:to_x) { 0 }
        let(:to_y) { 1 }

        it { is_expected.to eq(true) }
      end
    end

    context 'for invalid move' do
      let(:to_x) { 4 }
      let(:to_y) { 2 }

      it { is_expected.to eq(false) }
    end
  end

end    