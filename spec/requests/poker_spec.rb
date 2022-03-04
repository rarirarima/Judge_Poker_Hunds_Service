require 'rails_helper'

RSpec.describe API::Ver1::Poker, type: :request do
  describe 'POST API' do
    context 'request correct data' do
      let(:params){{"cards": ["H1 H2 H3 H4 H13", "S1 D1 C1 H1 H10"]}}
      it "正常にアクセスできる" do
        post "/api/ver1/poker", params: params
        expect(response).to be_success
      end
    end
  end
end
