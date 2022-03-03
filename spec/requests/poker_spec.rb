require 'rails_helper'

RSpec.describe API::Ver1::Poker, :type => :request do
  describe 'POST API' do
    context 'request correct data' do
      let(:params){{"cards": ["H1 H2 H3 H4 H13", "S1 D1 C1 H1 H10"]}}
      it "return cards & hunds & best" do
        post "/api/ver1/poker", params: params
        response_body = JSON.parse(response.body)
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response_body['result'][0]['card']).to eq "H1 H2 H3 H4 H13"
      end
    end
  end
end
