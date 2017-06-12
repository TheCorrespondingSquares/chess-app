require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

	describe "#pawn_valid_move?" do
    subject(:pawn_valid_move?) { pawn.pawn_valid_move?(destination_x, destination_y) }

    let!(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 1, game_id: game.id) }

    context 'for valid move' do
      context 'vertical first move' do
        let(:destination_x) { pawn.x_pos }
        let(:destination_y) { 3 }

        it { is_expected.to eq(true) }      
      end

      context 'vertical' do
        let(:destination_x) { pawn.x_pos }
        let(:destination_y) { 2 }

        it { is_expected.to eq(true) }
      end
	  end

    context 'for invalid move' do
      context '2 squares other than first move' do
        let(:destination_x) { 3 }
        let(:destination_y) { 4 }

        it { is_expected.to eq(false) }   
      end

      context 'diagonal without capture' do
  
    let(:destination_x) {4}
        let(:destination_y) {2}

        it { is_expected.to eq(false) } 
      end

      context 'backward vertical move' do
        let(:destination_x) { 3 }
        let(:destination_y) { 0 }

        it { is_expected.to eq(false) }   
      end

      context 'horizontal move' do
        let(:destination_x) { 4 }
        let(:destination_y) { 1 }

        it { is_expected.to eq(false) }   
      end
    end
  end
end