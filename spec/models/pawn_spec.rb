require 'rails_helper'

RSpec.describe Pawn, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id) }
  before(:each) { game.pieces.destroy_all }

  describe "#en_passant?" do
  subject(:en_passant?) { pawn.en_passant?(to_x, to_y, capture_pawn) }

    context 'for pawns first move is directly two squares' do
      it "should update the white pawn to do en_passant" do
        white_pawn = FactoryGirl.create(:pawn, color: "White", x_pos: 5, y_pos: 6, game_id: game.id)
        black_pawn = FactoryGirl.create(:pawn, color: "Black", x_pos: 4, y_pos: 4, game_id: game.id)

        white_pawn.vertical_move_only?(5, 4)
        black_pawn.en_passant?(5, 5, white_pawn)

        expect(white_pawn.is_on_square?(5, 4)).to eq(false)
      end

      it "should update the black pawn to do en_passant" do
        black_pawn = FactoryGirl.create(:pawn, color: "Black", x_pos: 5, y_pos: 1, game_id: game.id)
        white_pawn = FactoryGirl.create(:pawn, color: "White", x_pos: 4, y_pos: 3, game_id: game.id)

        black_pawn.vertical_move_only?(5, 3)
        white_pawn.en_passant?(5, 2, black_pawn)

        expect(black_pawn.is_on_square?(5, 3)).to eq(false)
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
