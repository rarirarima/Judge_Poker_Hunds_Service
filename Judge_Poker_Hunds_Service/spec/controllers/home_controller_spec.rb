require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #top' do
    it 'return 200' do
      get :top
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #show' do
    it 'return 302' do
      post :show
      expect(response).to have_http_status(302)
    end

    it 'redirect to top page' do
      post :show
      expect(response).to redirect_to '/'
    end
  end
end
