require 'rails_helper'

RSpec.describe Piece, type: :model do

  describe "#right_or_left" do
    subject(:right_or_left) { piece.right_or_left(destination_x) }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:game) { FactoryGirl.create(:game, user_id: user.id)}
    let!(:piece) { FactoryGirl.create(:piece, x_pos: 3, y_pos: 3, user_id: user.id, game_id: game.id) }

    context 'moving right' do
      let(:destination_x) { 5 }

      it { is_expected.to eq(1) }
    end

    context 'moving left' do
      let(:destination_x) { 2 }

      it { is_expected.to eq(-1) }
    end
  end

  describe "#up_or_down" do
    subject(:up_or_down) { piece.up_or_down(destination_y) }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:game) { FactoryGirl.create(:game, user_id: user.id)}
    let!(:piece) { FactoryGirl.create(:piece, x_pos: 3, y_pos: 3, user_id: user.id, game_id: game.id) }

    context 'moving up' do
      let(:destination_y) { 7 }

      it { is_expected.to eq(1) }
    end

    context 'moving down' do
      let(:destination_y) { 0 }

      it { is_expected.to eq(-1) }
    end
  end

  describe "#is_on_square?" do
    subject(:is_on_square?) { piece.is_on_square?(x, y) }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:game) { FactoryGirl.create(:game, user_id: user.id)}    
    let!(:piece) { FactoryGirl.create(:piece, x_pos: 1, y_pos: 1, user_id: user.id, game_id: game.id) }

    context 'when piece exist at coordinates' do
      let(:x) { 1 }
      let(:y) { 1 }

      it { is_expected.to eq(true) }
    end

    context 'when no piece exist at coordinates' do
      let(:x) { 0 }
      let(:y) { 0 }

      it { is_expected.to eq(false) }
    end
  end

  describe "#is_obstructed?" do
    subject(:is_obstructed?) { piece_move.is_obstructed?(destination_x, destination_y) }

    let!(:user) { FactoryGirl.create(:user) }
    let!(:game) { FactoryGirl.create(:game, user_id: user.id)}  
    let!(:piece_move) { FactoryGirl.create(:piece, name: name, x_pos: x_start, y_pos: y_start, user_id: user.id, game_id: game.id) }
    
    describe "for Knight (can't be obstructed)" do
      let!(:name) { "Knight" }
      let(:x_start) { 3 }
      let(:y_start) { 2 }
      let(:destination_x) { 5 }
      let(:destination_y) { 3 }

      it { is_expected.to eq("invalid") }
    end

    describe "for obstruction" do
      let!(:name) { "Queen" }
      let!(:piece_obstruct) { FactoryGirl.create(:piece, name: name_obstruct, x_pos: x_obstruct, y_pos: y_obstruct, user_id: user.id, game_id: game.id) }      

      context 'horizontal' do
        let(:x_start) { 3 }
        let(:y_start) { 3 }
        let(:destination_x) { 0 }
        let(:destination_y) { 3 }

        let(:name_obstruct) { "Bishop" }
        let(:x_obstruct) { 1 }
        let(:y_obstruct) { 3 }

        it { is_expected.to eq(true) }
      end

      context 'vertical' do
        let(:x_start) { 5 }
        let(:y_start) { 5 }    
        let(:destination_x) { 5 }
        let(:destination_y) { 1 }

        let(:name_obstruct) { "Pawn" }
        let(:x_obstruct) { 5 }
        let(:y_obstruct) { 2 }        

        it { is_expected.to eq(true) }
      end

      context 'diagonal' do
        let(:x_start) { 4 }
        let(:y_start) { 4 }        
        let(:destination_x) { 0 }
        let(:destination_y) { 0 }

        let(:name_obstruct) { "Knight" }
        let(:x_obstruct) { 2 }
        let(:y_obstruct) { 2 }          

        it { is_expected.to eq(true) }
      end      
    end

    describe "for no obstruction" do
      let!(:name) { "Queen" }
      let!(:piece_no_obstruct) { FactoryGirl.create(:piece, name: name_no_obstruct, x_pos: x_no_obstruct, y_pos: y_no_obstruct, user_id: user.id, game_id: game.id) }

      context 'horizontal' do
        let(:x_start) { 2 }
        let(:y_start) { 5 }            
        let(:destination_x) { 6 }
        let(:destination_y) { 5 }

        let(:name_no_obstruct) { "Rook" }
        let(:x_no_obstruct) { 6 }
        let(:y_no_obstruct) { 5 }

        it { is_expected.to eq(false) }
      end

      context 'vertical' do
        let(:x_start) { 7 }
        let(:y_start) { 1 }
        let(:destination_x) { 7 }
        let(:destination_y) { 6 }

        let(:name_no_obstruct) { "Pawn" }
        let(:x_no_obstruct) { 7 }
        let(:y_no_obstruct) { 6 }       

        it { is_expected.to eq(false) }
      end

      context 'for no diagonal obstruction' do
        let(:x_start) { 2 }
        let(:y_start) { 5 }        
        let(:destination_x) { 6 }
        let(:destination_y) { 1 }

        let(:name_no_obstruct) { "Bishop" }
        let(:x_no_obstruct) { 6 }
        let(:y_no_obstruct) { 1 }          

        it { is_expected.to eq(false) }
      end
    end

  end

end