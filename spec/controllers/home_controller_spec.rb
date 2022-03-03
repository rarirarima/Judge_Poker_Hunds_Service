require 'rails_helper'

RSpec.describe HomeController do
  describe 'GET #top' do
    it 'return 200' do
      get :top
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #judge' do
    it 'return 302' do
      post :judge
      expect(response).to have_http_status(302)
    end

    it 'redirect to top page' do
      post :judge
      expect(response).to redirect_to 'http://localhost:3000'
    end
  end

end