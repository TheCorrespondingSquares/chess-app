require 'rails_helper'

RSpec.describe Piece, type: :model do
  
  describe "is_occupied? method" do

    it "should return true if piece exists at coordinates" do
      piece = FactoryGirl.create(:piece, x_pos: 3, y_pos: 3)
      
      expect(piece.is_on_square?(piece.x_pos, piece.y_pos)).to eq(true)
    end

    it "should return false if no piece exists at coordinates" do
      piece = FactoryGirl.create(:piece, x_pos: 4, y_pos: 5)

      expect(piece.is_on_square?(piece.x_pos - 1, piece.y_pos)).to eq(false)
    end
  end

end
