require 'rails_helper'

RSpec.describe Game, type: :model do
	let!(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}

  describe '.available' do
  	let!(:user2) { FactoryGirl.create(:user) }

  	context 'only showing one available game' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id) }
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id, white_player_id: user.id)}

  		it 'should only show 1 available game' do
  			expect(Game.available.count).to eq 1
  			expect(Game.available.last).to eq game1
  		end
    end

  	context 'all available games' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id)}
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id)}

  		it 'should only show 1 available game' do
  			expect(Game.available.count).to eq 2
  			expect(Game.available.last).to eq game2
  		end
    end

  	context 'no available games' do
  		let!(:game1) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id)}
  		let!(:game2) { FactoryGirl.create(:game, black_player_id: user2.id, white_player_id: user.id)}

  		it 'should not show any game' do
  			expect(Game.available.count).to eq 0
  		end
    end

  end
end
