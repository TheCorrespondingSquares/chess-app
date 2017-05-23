require 'rails_helper'

RSpec.describe Piece, type: :model do
  
  describe "is_occupied? method" do
    it "should return true if piece exists at coordinates" do
      game = FactoryGirl.create(:game)
      piece = FactoryGirl.create(:piece, game_id: game.id)

      is_occupied?(piece.x_pos, piece.y_pos)
      expect(response).to eq(true)
    end

    it "should return false if no piece exists at coordinates" do
      game = FactoryGirl.create(:game)
      piece = FactoryGirl.create(:piece, game_id: game.id)
      empty_x = piece.x_pos - 1

      is_occupied?(empty_x, piece.y_pos)
      expect(response).to eq(false)
    end
  end

  # describe "is_obstructed? method" do
  #   it "should return error message if piece is a knight"

  #   end

  #   it "should return true for vertical obstruction" do
  #     game = FactoryGirl.create(:game)
  #     piece_moves = FactoryGirl.create(:piece, game_id: game.id)
  #     piece_obstructs = FactoryGirl.create(:piece, name: "pawn", x_pos: piece_moves.x_pos, y_pos: piece_moves.y_pos + 2, game_id: game.id)

  #     piece_moves.is_obstructed?(piece_moves.x_pos, piece_moves.y_pos + 4)
  #     expect(response).to eq(true)
  #   end

  #   it "should return false for no veritcal obstruction" do

  #   end

  #   it "should return true for horizontal obstruction" do
  #     game = FactoryGirl.create(:game)
  #     piece_moves = FactoryGirl.create(:piece, game_id: game.id)
  #     piece_obstructs = FactoryGirl.create(:piece, name: "pawn", x_pos: piece_moves.x_pos - 2, y_pos: piece_moves.y_pos, game_id: game.id)

  #     piece_moves.is_obstructed?(piece_moves.x_pos - 3, piece_moves.y_pos)
  #     expect(response).to eq(true)
  #   end

  #   it "should return false for no horizontal obstruction" do

  #   end

  #   it "should return true for diagonal obstruction" do
  #     game = FactoryGirl.create(:game)
  #     piece_moves = FactoryGirl.create(:piece, game_id: game.id)
  #     piece_obstructs = FactoryGirl.create(:piece, name: "pawn", x_pos: piece_moves.x_pos + 2, y_pos: piece_moves.y_pos + 2, game_id: game.id)

  #     piece_moves.is_obstructed?(piece_moves.x_pos + 4, piece_moves.y_pos + 4)
  #     expect(response).to eq(true)
  #   end

  #   it "should return false for no diagonal obstruction" do

  #   end
  # end

end
