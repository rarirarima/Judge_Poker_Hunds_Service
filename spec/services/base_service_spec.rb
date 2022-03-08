require 'rails_helper'

RSpec.describe BaseService do
  describe 'String request' do
    describe 'Judge hunds' do
      let(:summary) { BaseService::Summarize.new }
      subject { summary.api_or_webapp(cards_list) }

      context 'all the same suit & 5 straight number' do
        let(:cards_list) { 'H1 H2 H3 H4 H13' }
        it { is_expected.to eq 'ストレートフラッシュ' }
      end

      context '4 cards with the same number' do
        let(:cards_list) { 'C1 D1 H1 S1 H7' }
        it { is_expected.to eq 'フォー・オブ・ア・カインド' }
      end

      context '3 cards with the same number & 2 other cards with the same number' do
        let(:cards_list) { 'C3 D3 H3 S10 D10' }
        it { is_expected.to eq 'フルハウス' }
      end

      context 'all the same suit' do
        let(:cards_list) { 'D2 D3 D6 D8 D13' }
        it { is_expected.to eq 'フラッシュ' }
      end

      context '5 straight number' do
        let(:cards_list) { 'C8 H9 D10 S11 H12' }
        it { is_expected.to eq 'ストレート' }
      end

      context '3 cards with the same number' do
        let(:cards_list) { 'C6 H6 D6 C1 S13' }
        it { is_expected.to eq 'スリー・オブ・ア・カインド' }
      end

      context '2 cards with the same number & other 2 cards with the same number' do
        let(:cards_list) { 'C2 H2 S10 S13 D10' }
        it { is_expected.to eq 'ツーペア' }
      end

      context '2 cards with the same number' do
        let(:cards_list) { 'C1 D1 S2 H5 S12' }
        it { is_expected.to eq 'ワンペア' }
      end

      context 'no hund' do
        let(:cards_list) { 'H1 D3 S8 C4 D11' }
        it { is_expected.to eq 'ハイカード' }
      end
    end

    describe 'error' do
      let(:summary) { BaseService::Summarize.new }
      subject { summary.api_or_webapp(cards_list) }

      context 'no card' do
        let(:cards_list) { '' }
        it { is_expected.to eq 'カードが入力されていません。' }
      end

      context 'nil card' do
        let(:cards_list) { nil }
        it { is_expected.to eq 'カードが入力されていません。' }
      end

      context 'less than 5 blocks' do
        let(:cards_list) { 'H2 S2 C3 D4' }
        it { is_expected.to eq '5つのカード指定文字を半角スペース区切りで入力してください。' }
      end

      context 'more than 5 blocks' do
        let(:cards_list) { 'D2 S5 H1 C3 S9 S13' }
        it { is_expected.to eq '5つのカード指定文字を半角スペース区切りで入力してください。' }
      end

      context 'the suit of 1st card is lowercase' do
        let(:cards_list) { 's1 S2 C8 D10 H13' }
        it { is_expected.to eq "1番目のカード指定文字(s1)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。" }
      end

      context 'the suit of all cards is lowercase' do
        let(:cards_list) { 'd1 c4 h13 s12 d5' }
        it {
          is_expected.to eq "1番目のカード指定文字(d1)が不正です。\n2番目のカード指定文字(c4)が不正です。\n3番目のカード指定文字(h13)が不正です。\n" +
                            "4番目のカード指定文字(s12)が不正です。\n5番目のカード指定文字(d5)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
        }
      end

      context 'the suit of 1st card does not exist' do
        let(:cards_list) { 'X1 S2 C8 D10 H13' }
        it { is_expected.to eq "1番目のカード指定文字(X1)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。" }
      end

      context 'the suit of all cards does not exist' do
        let(:cards_list) { 'V2 W3 X7 Y8 Z13' }
        it {
          is_expected.to eq "1番目のカード指定文字(V2)が不正です。\n2番目のカード指定文字(W3)が不正です。\n3番目のカード指定文字(X7)が不正です。\n" +
                            "4番目のカード指定文字(Y8)が不正です。\n5番目のカード指定文字(Z13)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
        }
      end

      context 'the number of 1st card does not exist' do
        let(:cards_list) { 'C99 D1 H3 D4 H5' }
        it { is_expected.to eq "1番目のカード指定文字(C99)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。" }
      end

      context 'the number of all cards does not exist' do
        let(:cards_list) { 'C0 D14 H-1 S100 H10000' }
        it {
          is_expected.to eq "1番目のカード指定文字(C0)が不正です。\n2番目のカード指定文字(D14)が不正です。\n3番目のカード指定文字(H-1)が不正です。\n" +
                            "4番目のカード指定文字(S100)が不正です。\n5番目のカード指定文字(H10000)が不正です。\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
        }
      end

      context '2 duplicate cards' do
        let(:cards_list) { 'D3 C8 S10 C8 D3' }
        it { is_expected.to eq 'カードが重複しています。' }
      end

      context '5 duplicate cards' do
        let(:cards_list) { 'S7 S7 S7 S7 S7' }
        it { is_expected.to eq 'カードが重複しています。' }
      end
    end
  end

  describe 'Array request' do
    let(:summary) { BaseService::Summarize.new }
    subject { summary.api_or_webapp(cards_list) }

    context 'one card in array' do
      let(:cards_list) { ['H1 H2 H3 H4 H13'] }
      it {
        is_expected.to eq({
                            "result": [
                              {
                                "card": 'H1 H2 H3 H4 H13',
                                "hand": 'ストレートフラッシュ',
                                "best": true
                              }
                            ]
                          })
      }
    end

    context 'all hunds request' do
      let(:cards_list) do
        [
          'H1 H2 H3 H4 H13',
          'C1 D1 H1 S1 H7',
          'C3 D3 H3 S10 D10',
          'D2 D3 D6 D8 D13',
          'C8 H9 D10 S11 H12',
          'C6 H6 D6 C1 S13',
          'C2 H2 S10 S13 D10',
          'C1 D1 S2 H5 S12',
          'H1 D3 S8 C4 D11'
        ]
      end
      it {
        is_expected.to eq(
          {
            "result": [
              {
                "card": 'H1 H2 H3 H4 H13',
                "hand": 'ストレートフラッシュ',
                "best": true
              },
              {
                "card": 'C1 D1 H1 S1 H7',
                "hand": 'フォー・オブ・ア・カインド',
                "best": false
              },
              {
                "card": 'C3 D3 H3 S10 D10',
                "hand": 'フルハウス',
                "best": false
              },
              {
                "card": 'D2 D3 D6 D8 D13',
                "hand": 'フラッシュ',
                "best": false
              },
              {
                "card": 'C8 H9 D10 S11 H12',
                "hand": 'ストレート',
                "best": false
              },
              {
                "card": 'C6 H6 D6 C1 S13',
                "hand": 'スリー・オブ・ア・カインド',
                "best": false
              },
              {
                "card": 'C2 H2 S10 S13 D10',
                "hand": 'ツーペア',
                "best": false
              },
              {
                "card": 'C1 D1 S2 H5 S12',
                "hand": 'ワンペア',
                "best": false
              },
              {
                "card": 'H1 D3 S8 C4 D11',
                "hand": 'ハイカード',
                "best": false
              }
            ]
          }
        )
      }
    end

    context '2 best card' do
      let(:cards_list) do
        [
          'S1 S2 S11 S12 S13',
          'H6 H7 H8 H9 H10'
        ]
      end
      it {
        is_expected.to eq({
                            "result": [
                              {
                                "card": 'S1 S2 S11 S12 S13',
                                "hand": 'ストレートフラッシュ',
                                "best": true
                              },
                              {
                                "card": 'H6 H7 H8 H9 H10',
                                "hand": 'ストレートフラッシュ',
                                "best": true
                              }
                            ]
                          })
      }
    end

    context 'all error request' do
      let(:cards_list) do
        [
          '',
          'H2 S2 C3 D4',
          's1 S2 C8 D10 H13',
          'X1 S2 C8 D10 H13',
          'C99 D1 H3 D4 H5',
          'D3 C8 S10 C8 D3'
        ]
      end
      it {
        is_expected.to eq({
                            "error": [
                              {
                                "card": '',
                                "msg": 'カードが入力されていません。'
                              },
                              {
                                "card": 'H2 S2 C3 D4',
                                "msg": '5つのカード指定文字を半角スペース区切りで入力してください。'
                              },
                              {
                                "card": 's1 S2 C8 D10 H13',
                                "msg": '1番目のカード指定文字(s1)が不正です。'
                              },
                              {
                                "card": 'X1 S2 C8 D10 H13',
                                "msg": '1番目のカード指定文字(X1)が不正です。'
                              },
                              {
                                "card": 'C99 D1 H3 D4 H5',
                                "msg": '1番目のカード指定文字(C99)が不正です。'
                              },
                              {
                                "card": 'D3 C8 S10 C8 D3',
                                "msg": 'カードが重複しています。'
                              }
                            ]
                          })
      }
    end
  end
end
