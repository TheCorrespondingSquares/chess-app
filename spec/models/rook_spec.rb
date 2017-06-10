require 'rails_helper'

RSpec.describe Rook, type: :model do
    let!(:user) {FactoryGirl.create :user}
    let!(:game) {FactoryGirl.create :game, white_player_id: user.id}
    before(:each) {game.pieces.destroy_all}
    
    describe "#rook_valid_move?" do
      subject(:rook_valid_move?) {rook.rook_valid_move?(to_x, to_y)}
      let(:rook) {FactoryGirl.create(:rook, x_pos: 0, y_pos: 0, color: 'White', game_id: game.id)}
        
        context "valid move" do
            context 'vertical_move' do
              let(:to_x) {0}
              let(:to_y) {3}
          
              it {is_expected.to eq(true)}
            end
        
            context "horizontal_move" do
              let(:to_y) {0}
              let(:to_x) {3}
          
              it {is_expected.to eq(true)}
            end
        end
        
        context 'for invalid move' do
          context 'horizontal_move' do
            let(:to_x) {0}
            let(:to_y) {1}
            
            it {is_expected.to eq(true)}
          end
          
          context 'for vertical_move' do
            let(:to_x) {0}
            let(:to_y) {2}
            
            it {is_expected.to eq(true)}
          end
        end
    end
end
