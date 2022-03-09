require 'rails_helper'

RSpec.describe API::Ver1::Poker, type: :request do
  describe 'POST API' do
    context 'correct cards' do
      let(:params) { { "cards": ['H1 H2 H3 H4 H13', 'S1 D1 C1 H1 H10'] } }
      before do
        post '/api/ver1/poker', params
      end
      it 'can access correctly' do
        expect(response).to be_success
      end
      it 'return http status code 200' do
        expect(response).to have_http_status(200)
      end
      it 'return judge result' do
        expect(JSON.parse(response.body)['result'][0]['hand']).to eq 'ストレートフラッシュ'
      end
    end

    describe 'self-made error' do
      context 'nothing is entered' do
        let(:params) { { "cards": [''] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カードが入力されていません。'
        end
      end

      context 'less than 5 cards' do
        let(:params) { { "cards": ['H1 H2 H3 H4'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context 'integer value in array' do
        let(:params) { { "cards": [123] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context '5th card is incorrect' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H100'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5番目のカード指定文字(H100)が不正です。'
        end
      end

      context '2 duplicate cards' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H1'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カードが重複しています。'
        end
      end
    end
  end

  describe 'validation error' do
    describe 'when request incorrect cards' do
      context 'value is string class' do
        let(:params) { { "cards": 'H1 H2 H3 H4 H5' } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'name of key is incorrect' do
        let(:params) { { "カード": ['H1 H2 H3 H4 H5'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'nothing in array' do
        let(:params) { { "cards": [] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'nothing in hash' do
        let(:params) { {} }
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'hash does not exist' do
        let(:params) {}
        before do
          post '/api/ver1/poker', params
        end
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end
    end

    describe 'JSON形式が不正であるプロパティ' do
      # context 'ハッシュが不正' do
      #   let(:params){{cards: ["H1 H2 H3 H4 H5"]}}
      #   before do
      #     post "/api/ver1/poker", params
      #   end
      #   it 'return http sratus code 400' do
      #     expect(response).to have_http_status(400)
      #   end
      #   it 'return error message' do
      #     expect(JSON.parse(response.body)["error"][0]["msg"]).to eq "JSON形式が不正です。"
      #   end
      # end

      # context '配列が不正' do
      #   let(:params){{"cards": "H1 H2 H3 H4 H5"}}
      #   before do
      #     post "/api/ver1/poker", params
      #   end
      #   it 'return http sratus code 400' do
      #     expect(response).to have_http_status(400)
      #   end
      #   it 'return error message' do
      #     expect(JSON.parse(response.body)["error"][0]["msg"]).to eq "JSON形式が不正です。"
      #   end
      # end
    end
  end
end
