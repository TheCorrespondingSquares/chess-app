require 'rails_helper'

RSpec.describe Rook, type: :model do
    let(:user) {FactoryGirl.create :user}
    let(:game) {FactoryGirl.create :game}
    before(:each) {game.destroy_all}
    
    describe "#rook_valid_move?" do
      subject(:rook_valid_move?) {rook.rook_valid_move?(destination_x, destination_y)}
      let(:rook) {FactoryGirl.create(:rook, x_pos: 0, y_pos: 0, color: 'White', game_id: game.id)}
        
        context "valid move" do 
          let(destination_x) {3}
          let(destination_y) {0}
          
          it {is_expected.to eq(true)}
        end
    end
end
