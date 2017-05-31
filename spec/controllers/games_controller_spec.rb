require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#index action' do
    it 'should successfully show the page' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#show action' do
  	it 'should successfully show the pieces which belong to the game' do

  		expect(@pieces.first).to be
  	end
  end	
end
