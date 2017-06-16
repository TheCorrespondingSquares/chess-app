require 'rails_helper'

RSpec.describe Game, type: :model do
	let!(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}

  describe '.available' do
  	let!(:user2) { FactoryGirl.create(:user) }

    context 'when some games are not available' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id) }
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id, white_player_id: user.id)}

      it 'show an available game' do
  			expect(Game.available.count).to eq 1
      end

  		it 'show the last available game' do
  			expect(Game.available.last).to eq game1
  		end
    end

    context 'when all games are available' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id)}
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id)}

      it 'show an available game' do
  			expect(Game.available.count).to eq 2
      end

			it 'show the last vailable game' do
				expect(Game.available.last).to eq game2
			end
    end

    context 'when all existing games are unavailable' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id)}
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id, white_player_id: user.id)}

  		it 'show any game' do
  			expect(Game.available.count).to eq 0
  		end
    end
  end

  describe "#check!" do
    let!(:game) { FactoryGirl.create(:game, white_player_id: user.id)}
    before(:each) { game.pieces.destroy_all }
    
    context ' when a rook moves' do
      let!(:king) { FactoryGirl.create(:king, color: "White", x_pos: 4, y_pos: 4, game_id: game.id) }
      let!(:piece_making_check) { FactoryGirl.create(:rook, color: "Black", captured: false, x_pos: to_x, y_pos: to_y, game_id: game.id) }
      let(:to_x) { 0 }
      let(:to_y) { 4 }

      it ' notifies when a king is in check position (rook)' do
        expect(game.check?(king.color)).to eq(true)
      end  
    end

    context ' when a bishop moves' do
      let!(:king) { FactoryGirl.create(:king, color: "White", x_pos: 4, y_pos: 4, game_id: game.id) }
      let!(:piece_making_check) { FactoryGirl.create(:bishop, color: "Black", captured: false, x_pos: to_x, y_pos: to_y, game_id: game.id) }
      let(:to_x) { 2 }
      let(:to_y) { 2 }

      it ' notifies when a king is in check position (bishop)' do
        expect(game.check?(king.color)).to eq(true)
      end  
    end   
  end 
end
