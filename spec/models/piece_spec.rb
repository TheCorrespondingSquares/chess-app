require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe "right_left method" do

    it "should return 1 if piece is moving to the right" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      expect(piece.right_left(5)).to eq(1)
    end

    it "should return -1 if piece is moving to the left" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)      
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      expect(piece.right_left(2)).to eq(-1)
    end

  end

  describe "up_down method" do

    it "should return 1 if piece is moving up" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)      
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      expect(piece.right_left(7)).to eq(1)
    end

    it "should return -1 if piece is moving down" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)         
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      expect(piece.right_left(0)).to eq(-1)
    end

  end
  
  describe "is_on_square? method" do

    it "should return true if piece exists at coordinates" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      expect(piece.is_on_square?(piece.x_pos, piece.y_pos)).to eq(true)
    end

    it "should return false if no piece exists at coordinates" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 4, y_pos: 5)
      expect(piece.is_on_square?(piece.x_pos - 1, piece.y_pos)).to eq(false)
    end

  end

  describe "knight_cant_be_obstructed method" do

    it "should return error message if piece is a knight" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)         
      piece = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Knight", x_pos: 1, y_pos: 3)
      expect(piece.knight_cant_be_obstructed).to eq("error - invalid input")
    end    

  end

  describe "is_obstructed? method" do

    it "should return TRUE for horizontal obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 3, y_pos: 3)
      piece_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Bishop", x_pos: 1, y_pos: 3)

      expect(piece_move.is_obstructed?(0, 3)).to eq(true)
    end

    it "should return FALSE for no horizontal obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 2, y_pos: 5)
      piece_no_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Rook", x_pos: 3, y_pos: 2)

      expect(piece_move.is_obstructed?(6, 5)).to eq(false)
    end

    it "should return TRUE for vertical obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 5, y_pos: 5)
      piece_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Pawn", x_pos: 5, y_pos: 2)

      expect(piece_move.is_obstructed?(5, 1)).to eq(true)
    end

    it "should return FALSE for no veritcal obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)        
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 7, y_pos: 1)
      piece_no_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Knight", x_pos: 2, y_pos: 4)

      expect(piece_move.is_obstructed?(7, 6)).to eq(false)
    end

    it "should return TRUE for diagonal obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)          
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 4, y_pos: 4)
      piece_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Bishop", color: "white", x_pos: 2, y_pos: 2)

      expect(piece_move.is_obstructed?(0, 0)).to eq(true)
    end

    it "should return FALSE for no diagonal obstruction" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, user_id: user.id)          
      piece_move = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, x_pos: 2, y_pos: 5)
      piece_no_obstruct = FactoryGirl.create(:piece, game_id: game.id, user_id: user.id, name: "Rook", x_pos: 5, y_pos: 1)

      expect(piece_move.is_obstructed?(6, 1)).to eq(false)      
    end    

  end

end
