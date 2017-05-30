require 'rails_helper'

RSpec.describe Game, type: :model do
	let(:user) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player_id: user.id)}

  describe '.available' do
  	let(:user2)   { FactoryGirl.create(:user)}

  	context 'there is 1 available game and 1 not available' do
      let!(:game_1) { FactoryGirl.create(:game, white_player_id: user.id) }
      let!(:game_2) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id) }

  	  it 'should only return games with one player' do
  	  	expect(Game.available.count).to eq 1
  		  expect(Game.available.first).to eq game_1
  	  end
    end

    context 'all games are available' do
      let!(:game_1) { FactoryGirl.create(:game, white_player_id: user.id) }
      let!(:game_2) { FactoryGirl.create(:game, white_player_id: user2.id) }

  	  it 'should list all games' do
  		  expect(Game.available.count).to eq 2
  		  expect(Game.available.last).to eq game_2
  	  end
    end

    context 'no game is available' do
      let!(:game_1) { FactoryGirl.create(:game, white_player_id: user2.id, black_player_id: user.id) }
      let!(:game_2) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id) }

  	  it 'should list no game at all' do
  		  expect(Game.available.count).to eq 0
  	  end
    end

  end
end
