require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }
  
  describe "#can_promote?" do
    subject(:can_promote?) {self.can_promote?(to_y)}
    
    context "for white pawn promotion" do
      let!(:pawn) {FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 1, game_id: game.id)}
      let(:to_y) {7}
      it { is_expected.to eq(true)}
    end
    
    context 'for black pawn promotion' do
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "Black", x_pos: 3, y_pos: 6, game_id: game.id)}
      let(:to_y) {0}
      it {is_expected.to eq(true)}
    end
  end

  describe "#valid_move?" do
    subject(:valid_move?) { pawn.valid_move?(to_x, to_y) }

    let!(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 1, game_id: game.id) }

    context 'for valid move' do
      context 'there is another piece (same color) on destination square' do
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 3, game_id: game.id) }
        let(:to_x) { 3 }
        let(:to_y) { 3 }

        it { is_expected.to eq(false) }
      end

      context 'there is another piece (opposite color) on destination square' do
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "Black", x_pos: 3, y_pos: 3, game_id: game.id) }
        let(:to_x) { 3 }
        let(:to_y) { 3 }

        it { is_expected.to eq(false) }
      end

      context 'vertical first move' do
        let(:to_x) { pawn.x_pos }
        let(:to_y) { 3 }

        it { is_expected.to eq(true) }
      end

      context 'vertical move of the opponent' do
        let(:pawn) { FactoryGirl.create(:pawn, color: "Black", x_pos: 3, y_pos: 5, game_id: game.id) }
        let(:to_x) { pawn.x_pos }
        let(:to_y) { 4 }
        
        it 'should be true' do
          expect(pawn.valid_move?(to_x, to_y)).to eq(true)
        end
      end

      context 'diagonal move' do
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 2, game_id: game.id) }
        let(:to_x) { 4 }
        let(:to_y) { 2 }

        it 'should be true' do
          expect(pawn.valid_move?(to_x, to_y)).to eq(true)
        end
      end
    end

    context 'not valid move' do
      context '2 squares other than first move' do
        let(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 2, game_id: game.id) }
        let(:to_x) { pawn.x_pos }
        let(:to_y) { 4 }

        it { is_expected.to eq(false) }   
      end

      context 'diagonal without capture' do
        let(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 1, game_id: game.id) }
        let(:to_x) { 4 }
        let(:to_y) { 2 }

        it 'should be false' do
          expect(pawn.valid_move?(to_x, to_y)).to eq(false)
        end
      end

      context 'backward vertical move' do
        let(:to_x) { 3 }
        let(:to_y) { 0 }

        it { is_expected.to eq(false) }   
      end

      context 'horizontal move' do
        let(:to_x) { 4 }
        let(:to_y) { 1 }

        it { is_expected.to eq(false) }   
      end
    end
  end
end