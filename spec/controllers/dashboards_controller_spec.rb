require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe 'dashboards#index action' do
    it 'should successfully show the page' do
      user = FactoryGirl.create(:user)
      sign_in user

      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
