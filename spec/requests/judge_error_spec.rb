require 'rails_helper'

RSpec.describe JudgeErrorBase do
  include JudgeErrorBase
  describe 'Array request' do
    let(:base) { JudgeErrorBase::Base.new(cards_list) }
    subject { base.api }

    context 'one card in array' do
      let(:cards_list) { ['H1 H10 H11 H12 H13'] }
      it {
        is_expected.to eq({
                            "result": [
                              {
                                "card": 'H1 H10 H11 H12 H13',
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
          'H1 H10 H11 H12 H13',
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
                "card": 'H1 H10 H11 H12 H13',
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

    context '2 best cards' do
      let(:cards_list) do
        [
          'S1 S10 S11 S12 S13',
          'H6 H7 H8 H9 H10'
        ]
      end
      it {
        is_expected.to eq({
                            "result": [
                              {
                                "card": 'S1 S10 S11 S12 S13',
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

    context 'judge & error request' do
      let(:cards_list) do
        [
          '',
          'H1 S3 S1 D1 C3',
          'H1 H1 H2 H3 H4',
          'C12 C10 C11 C1 C13',
          'H100 D1 D2 D3 D4'
        ]
      end
      it {
        is_expected.to eq({
                            "result": [
                              {
                                "card": 'H1 S3 S1 D1 C3',
                                "hand": 'フルハウス',
                                "best": false
                              },
                              {
                                "card": 'C12 C10 C11 C1 C13',
                                "hand": 'ストレートフラッシュ',
                                "best": true
                              }
                            ],
                            "error": [
                              {
                                "card": '',
                                "msg": 'カードが入力されていません。'
                              },
                              {
                                "card": 'H1 H1 H2 H3 H4',
                                "msg": 'カードが重複しています。'
                              },
                              {
                                "card": 'H100 D1 D2 D3 D4',
                                "msg": '1番目のカード指定文字(H100)が不正です。'
                              }
                            ]
                          })
      }
    end
  end
end
