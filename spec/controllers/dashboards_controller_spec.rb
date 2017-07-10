require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  describe 'dashboards#index action' do
    it 'should successfully show the page' do
<<<<<<< HEAD
=======
      user = FactoryGirl.create(:user)
      sign_in user

>>>>>>> c4e8379fa23c67baed3d173f2f1a977ba399adb1
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
