require 'rails_helper'

RSpec.describe King, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  let(:king) { FactoryGirl.create(:king, color: "Black", x_pos: 3, y_pos: 0, game_id: game.id) }
  before(:each) { game.pieces.destroy_all }

  describe "king#valid_move?" do
    subject(:king_valid_move?) { king.valid_move?(destination_x, destination_y) }

    context 'for horizontal move' do
      let(:destination_y) { king.y_pos }

      context 'when valid' do
        let(:destination_x) { 2 }
        
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
        let(:destination_x) { 2 }
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
    
  describe "King#castle" do
  subject(:king_castle) {King.castle(to_x, to_y)}
    
    context 'for left move' do
      let(:to_y) {king.y_pos}
      
      context 'when king already moved' do
        let!(self.moved?) {true}
        it { is_expected.to eq(nil)}
      end
      
      context "when rook moved" do 
        let(rook.moved?) {true}
        
        it {is_expected.to eq(nil)}
      end
    end
  end
end  