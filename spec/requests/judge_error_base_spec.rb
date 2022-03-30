require 'rails_helper'

RSpec.describe JudgeErrorBase do
  include JudgeErrorBase
  describe 'Array request' do
    let(:judge_error_base) { JudgeErrorBase::Base.new(cards_list) }
    let(:api_response) { judge_error_base.process_api }

    context 'one card in array' do
      let(:cards_list) { ['H1 H10 H11 H12 H13'] }
      it 'return result' do
        expect(api_response).to eq({
                                     "result": [
                                       {
                                         "card": 'H1 H10 H11 H12 H13',
                                         "hand": 'ストレートフラッシュ',
                                         "best": true
                                       }
                                     ]
                                   })
      end
    end

    context 'correct cards request' do
      let(:cards_list) do
        [
          'H1 H10 H11 H12            H13',
          'C1 D1 H1 S1 H7',
          'C3 D3 H3 S10 D10',
          'D2 D3 D6 D8 D13',
          'C8 H9 D10 S11 H12',
          'C6 H6 D6 C1 S13',
          'C2 H2 S10 S13 D10',
          'C1 D1 S2 H5 S12',
          'H1 D3 S8 C4 D11',
          'C1 C13 C10 C12 C11',
          'D3 D4 D5 D6 D7',
          'C3 S3 H3 D10 H4',
          'H10 D10 C3 S3 D4',
          'D11 S11 C11 H5 S5'
        ]
      end
      it 'has 14 results' do
        expect(api_response[:result].count).to eq 14
      end

      it 'has 3 straight-flash cards' do
        hand_count = 0
        api_response[:result].each do |result|
          hand_count += 1 if result[:hand] == 'ストレートフラッシュ'
        end
        expect(hand_count).to eq 3
      end

      it 'has 3 best cards' do
        best_count = 0
        api_response[:result].each do |result|
          best_count += 1 if result[:best] == true
        end
        expect(best_count).to eq 3
      end

      it '1st & 10th & 11th result is best' do
        expect(api_response[:result][0][:best]).to eq true
        expect(api_response[:result][9][:best]).to eq true
        expect(api_response[:result][10][:best]).to eq true
      end

      it 'does not have error' do
        expect(api_response[:error].nil?).to eq true
      end

      it 'spaces of 1st cards are modified' do
        expect(api_response[:result][0][:card]).to eq 'H1 H10 H11 H12 H13'
      end
    end

    context 'error cards request' do
      let(:cards_list) do
        [
          '',
          'H2 S2 C3 D4',
          's1 S2 C8 D10 H13',
          'X1 S2 C8 D10 H13',
          'C99 D1 H3 D4 H5',
          'D3 C8 S10 C8 D3',
          'S1000',
          'D10 S11 C12 H1 D3 S4',
          's1 D2 H3 x3 Z10',
          '1H 2H 3H 4H 5H',
          'S1 S1 S1 S1 S1',
          '       '
        ]
      end
      it 'has 18 errors' do
        expect(api_response[:error].count).to eq 18
      end

      it 'has 2 no-5-cards-error messages' do
        msg_count = 0
        api_response[:error].each do |error|
          msg_count += 1 if error[:msg] == '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
        expect(msg_count).to eq 3
      end

      it '1st & last errors are empty-card error' do
        expect(api_response[:error][0][:msg]).to eq 'カードが入力されていません。'
        expect(api_response[:error][17][:msg]).to eq 'カードが入力されていません。'
      end

      it 'does not have error' do
        expect(api_response[:result].nil?).to eq true
      end
    end

    context 'judge & error request' do
      let(:cards_list) do
        [
          '',
          'H1 S3 S1 D1 C3',
          'H1 H1 H2 H3 H4',
          'C12 C10 C11 C1 C13',
          'H100 D1 D2 D3 D4',
          'h2 h3 h4 h5 h6',
          'H10 H11 S12 C13 C1',
          'D10 S10 C10 D4 H4',
          'D10 S11 H12 S13 D14',
          'H0 D1 S2 D3 H4',
          'H1 D3 S4 S6 C9',
          'S2 D3 S3 C7 D10 C4',
          'D3 S1 S9',
          'S2 S2 S2 S2 S2'
        ]
      end

      it 'has 5 results' do
        expect(api_response[:result].count).to eq 5
      end

      it 'has 13 errors' do
        expect(api_response[:error].count).to eq 13
      end

      it 'has 2 fullhause' do
        hand_count = 0
        api_response[:result].each do |result|
          hand_count += 1 if result[:hand] == 'フルハウス'
        end
        expect(hand_count).to eq 2
      end

      it 'has 2 duplicate-error messages' do
        msg_count = 0
        api_response[:error].each do |error|
          msg_count += 1 if error[:msg] == '5つのカード指定文字を半角スペース区切りで入力してください。'
        end
        expect(msg_count).to eq 2
      end

      it '2nd result is best' do
        expect(api_response[:result][1][:best]).to eq true
      end
    end
  end
end
