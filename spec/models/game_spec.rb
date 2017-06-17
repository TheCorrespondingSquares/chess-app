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

  describe "#check?" do
    subject(:check?) { game.check?(king.color) }
    let(:king) { FactoryGirl.create(:king, color: "White", x_pos: 4, y_pos: 0, game_id: game.id) }
    before(:each) { game.pieces.destroy_all }

    
    context 'when a Rook puts King in check' do
      let!(:piece_making_check) { FactoryGirl.create(:rook, color: "Black", captured: false, x_pos: 0, y_pos: 0, game_id: game.id) }

      it { is_expected.to eq(true) }
    end

    context 'when a Bishop puts King in check' do
      let!(:piece_making_check) { FactoryGirl.create(:bishop, color: "Black", captured: false, x_pos: 2, y_pos: 2, game_id: game.id) }

      it { is_expected.to eq(true) } 
    end

    context 'when a piece does not put King in check' do
      let!(:piece_doesnt_check) { FactoryGirl.create(:queen, color: "Black", captured: false, x_pos: 2, y_pos: 3, game_id: game.id) }

      it { is_expected.to eq(false) } 
    end       
  end

end
