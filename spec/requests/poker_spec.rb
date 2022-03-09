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
      before do
        post '/api/ver1/poker', params
      end
      let(:error_msg){JSON.parse(response.body)['error'][0]['msg']}
      shared_examples 'return http status code 400' do
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
      end
      context 'nothing is entered' do
        let(:params) { { "cards": [''] } }
        it_behaves_like 'return http status code 400'
        it 'return error message' do
          expect(error_msg).to eq 'カードが入力されていません。'
        end
      end

      context 'less than 5 cards' do
        let(:params) { { "cards": ['H1 H2 H3 H4'] } }
        it_behaves_like 'return http status code 400'
        it 'return error message' do
          expect(error_msg).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context 'integer value in array' do
        let(:params) { { "cards": [123] } }
        it_behaves_like 'return http status code 400'
        it 'return error message' do
          expect(error_msg).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context '5th card is incorrect' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H100'] } }
        it_behaves_like 'return http status code 400'
        it 'return error message' do
          expect(error_msg).to eq '5番目のカード指定文字(H100)が不正です。'
        end
      end

      context '2 duplicate cards' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H1'] } }
        it_behaves_like 'return http status code 400'
        it 'return error message' do
          expect(error_msg).to eq 'カードが重複しています。'
        end
      end
    end
  end

  describe 'validation error' do
    describe 'when request incorrect cards' do
      before do
        post '/api/ver1/poker', params
      end
      let(:error_msg){JSON.parse(response.body)['error'][0]['msg']}
      shared_examples 'return http status code 400 & error message' do
        it 'return http sratus code 400' do
          expect(response).to have_http_status(400)
        end
        it 'return error message' do
          expect(error_msg).to eq 'カード情報が不正です。'
        end
      end
      context 'value is string class' do
        let(:params) { { "cards": 'H1 H2 H3 H4 H5' } }
        it_behaves_like 'return http status code 400 & error message'
      end

      context 'name of key is incorrect' do
        let(:params) { { "カード": ['H1 H2 H3 H4 H5'] } }
        it_behaves_like 'return http status code 400 & error message'
      end

      context 'nothing in array' do
        let(:params) { { "cards": [] } }
        it_behaves_like 'return http status code 400 & error message'
      end

      context 'nothing in hash' do
        let(:params) { {} }
        it_behaves_like 'return http status code 400 & error message'
      end

      context 'hash does not exist' do
        let(:params) {}
        it_behaves_like 'return http status code 400 & error message'
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
