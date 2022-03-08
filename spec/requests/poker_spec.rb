require 'rails_helper'

RSpec.describe API::Ver1::Poker, type: :request do
  describe 'POST API' do
    context '正しいカードプロパティ' do
      let(:params) { { "cards": ['H1 H2 H3 H4 H13', 'S1 D1 C1 H1 H10'] } }
      before do
        post '/api/ver1/poker', params
      end
      it '正常にアクセスできる' do
        expect(response).to be_success
      end
      it 'ステータスコード200' do
        expect(response).to have_http_status(200)
      end
      it '役判定に成功' do
        expect(JSON.parse(response.body)['result'][0]['hand']).to eq 'ストレートフラッシュ'
      end
    end

    describe '独自エラーを出すプロパティ' do
      context 'カード未入力' do
        let(:params) { { "cards": [''] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'エラー判定に成功' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カードが入力されていません。'
        end
      end

      context 'カード数不正' do
        let(:params) { { "cards": ['H1 H2 H3 H4'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'エラー判定に成功' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context 'パラメータの中身がint型' do
        let(:params) { { "cards": [123] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'エラー判定に成功' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
      end

      context '指定文字が不正' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H100'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'エラー判定に成功' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq '5番目のカード指定文字(H100)が不正です。'
        end
      end

      context 'カードが重複' do
        let(:params) { { "cards": ['H1 H2 H3 H4 H1'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'エラー判定に成功' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カードが重複しています。'
        end
      end
    end
  end

  describe 'バリデーションエラー' do
    describe 'カード情報が不正であるプロパティ' do
      context 'カードが配列に入っていない' do
        let(:params) { { "cards": 'H1 H2 H3 H4 H5' } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'バリデーション' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'パラメータ名が不正' do
        let(:params) { { "カード": ['H1 H2 H3 H4 H5'] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'バリデーション' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context '配列が空' do
        let(:params) { { "cards": [] } }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'バリデーション' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'ハッシュが空' do
        let(:params) { {} }
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'バリデーション' do
          expect(JSON.parse(response.body)['error'][0]['msg']).to eq 'カード情報が不正です。'
        end
      end

      context 'パラメータ自体が空' do
        let(:params) {}
        before do
          post '/api/ver1/poker', params
        end
        it 'ステータスコード400' do
          expect(response).to have_http_status(400)
        end
        it 'バリデーション' do
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
      #   it 'ステータスコード400' do
      #     expect(response).to have_http_status(400)
      #   end
      #   it 'バリデーション' do
      #     expect(JSON.parse(response.body)["error"][0]["msg"]).to eq "JSON形式が不正です。"
      #   end
      # end

      # context '配列が不正' do
      #   let(:params){{"cards": "H1 H2 H3 H4 H5"}}
      #   before do
      #     post "/api/ver1/poker", params
      #   end
      #   it 'ステータスコード400' do
      #     expect(response).to have_http_status(400)
      #   end
      #   it 'バリデーション' do
      #     expect(JSON.parse(response.body)["error"][0]["msg"]).to eq "JSON形式が不正です。"
      #   end
      # end
    end
  end
end
