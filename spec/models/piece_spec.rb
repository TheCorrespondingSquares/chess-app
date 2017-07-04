require 'rails_helper'

RSpec.describe Piece, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, black_player_id: user.id)}
  before(:each) { game.pieces.destroy_all }

  describe "#capture_piece!" do
    let(:piece_capturer) { FactoryGirl.create(:bishop, color: "Black", x_pos: 7, y_pos: 3, game_id: game.id) }
    let(:piece_target) { FactoryGirl.create(:pawn, color: "White", x_pos: target_x, y_pos: target_y, game_id: game.id) }
    let(:target_x) { 5 }
    let(:target_y) { 5 }
    
    it ', remove opposing piece from board and update piece position' do
      expect(piece_target.x_pos).to eq(target_x)
      expect(piece_target.y_pos).to eq(target_y)

      piece_capturer.capture_piece!(target_x, target_y, piece_target)
      piece_target.reload

      expect(piece_target.x_pos).to eq(nil)
      expect(piece_target.y_pos).to eq(nil)
      expect(piece_target.captured).to eq(true)
    end  
  end    

  describe "#move_to!" do
    let(:piece_moving) { FactoryGirl.create(:queen, color: "Black", x_pos: 7, y_pos: 7, game_id: game.id) }
    let(:destination_x) { 6 }
    let(:destination_y) { 6 }

    context 'empty square' do
      it 'and update piece position' do
        piece_moving.move_to!(destination_x, destination_y)
        expect(piece_moving.x_pos).to eq(destination_x)
        expect(piece_moving.y_pos).to eq(destination_y)
      end
    end

    context 'move and capture' do
      let(:other_piece) { FactoryGirl.create(:knight, color: other_color, x_pos: destination_x, y_pos: destination_y, game_id: game.id) }

      context 'capture opponent\'s piece' do
        let(:other_color) { "White" }

        it ', update positions of moving piece and captured piece' do
          expect(other_piece.x_pos).to eq(destination_x)
          expect(other_piece.y_pos).to eq(destination_x)

          piece_moving.move_to!(destination_x, destination_y)
          other_piece.reload

          expect(other_piece.x_pos).to eq(nil)
          expect(other_piece.y_pos).to eq(nil)
          expect(other_piece.captured).to eq(true)
          expect(piece_moving.x_pos).to eq(destination_x)
          expect(piece_moving.y_pos).to eq(destination_y)
        end
      end

      context 'cannot move or capture if your own piece is there' do
        let(:other_color) { "Black" }

        it ', piece positions do not change' do
          expect(other_piece.x_pos).to eq(destination_x)
          expect(other_piece.y_pos).to eq(destination_x)

          piece_moving.move_to!(destination_x, destination_x)
          other_piece.reload

          expect(other_piece.x_pos).to eq(destination_x)
          expect(other_piece.y_pos).to eq(destination_x)
          expect(other_piece.captured).to eq(false)
          expect(piece_moving.x_pos).to eq(7)
          expect(piece_moving.y_pos).to eq(7)
        end
      end
    end      
  end
  
end
