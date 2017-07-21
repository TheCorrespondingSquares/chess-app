require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id) }
  # let(:game) { FactoryGirl.create(:game, black_player_id: user.id) }
  before(:each) { game.pieces.destroy_all }
  
  describe "#can_enpassant?" do
    subject(:enpassant) {pawn.can_enpassant?(to_x, to_y)}
    
    let!(:pawn) {FactoryGirl.create(:pawn, color: "Black", x_pos: 3, y_pos: 3, game_id: game.id)}
    let(:to_x) { 2 }
    let(:to_y) { 2 }

    context 'when there is an adjacent opponent pawn that has moved once' do
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "White", x_pos: 2, y_pos: 3, game_id: game.id, turn: 1)}

      it { is_expected.to eq(true) }
      # it 'should be true' do
      #   expect(pawn.can_enpassant?).to be true
      # end
    end
    
    context 'when there is not an adjacent opponent pawn' do
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "White", x_pos: 1, y_pos: 3, game_id: game.id, turn: 1)}

      it { is_expected.to eq(false) }
      # it "should be false" do
      #   expect(pawn.can_enpassant?).to be false
      # end
    end
    
    context 'when there is an adjacent opponent pawn but is not first move' do
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "White", x_pos: 2, y_pos: 3, game_id: game.id, turn: 2)}

      it { is_expected.to eq(false) }
      # it 'is expected to be false' do
      #   expect(pawn.can_enpassant?).to be false
      # end
    end
    
    context 'when adjacent pawn is NOT opponent pawn' do
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "Black", x_pos: 2, y_pos: 3, game_id: game.id, turn: 1)}

      it { is_expected.to eq(false) }
      # it 'is expected to be false' do
      #   expect(pawn.can_enpassant?).to be false
      # end
    end
    
    context 'when adjacent opponent pawn and pawn are in the middle of board' do
      let!(:pawn) {FactoryGirl.create(:pawn, color: "Black", x_pos: 3, y_pos: 4, game_id: game.id)}
      let!(:pawn2) {FactoryGirl.create(:pawn, color: "White", x_pos: 2, y_pos: 4, game_id: game.id, turn: 2)}
      let(:to_x) { 2 }
      let(:to_y) { 3 }

      it { is_expected.to eq(false) }
      # it 'should be false' do
      #   expect(pawn.can_enpassant?).to be false
      # end
    end
  end

  describe "#move_to!" do
    context "for a valid enpassant move" do
      it "should successfully capture piece on adjacent square" do

      end
    end

    context "for an invalid enpassant move" do
      it "should leave game unchanged" do

      end
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

        it { is_expected.to eq(true) }
      end

      context 'diagonal move with capture' do
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 2, game_id: game.id) }
        let(:to_x) { 4 }
        let(:to_y) { 2 }

        it { is_expected.to eq(true) }
      end

      context 'enpassant move' do
        let!(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 4, game_id: game.id) }
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 4, game_id: game.id, turn: 1) }
        let(:to_x) { 4 }
        let(:to_y) { 5 }

        it { is_expected.to eq(true) }
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

        it { is_expected.to eq(false) }
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

      context 'invalid enpassant move' do
        let!(:pawn) { FactoryGirl.create(:pawn, color: "White", x_pos: 3, y_pos: 4, game_id: game.id) }
        let!(:pawn2) { FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 4, game_id: game.id, turn: 1) }
        let(:to_x) { 2 }
        let(:to_y) { 5 }

        it { is_expected.to eq(false) }        
      end
    end
  end
end
