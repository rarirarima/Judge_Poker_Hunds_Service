require 'rails_helper'

RSpec.describe StrengthService do
  include StrengthService
  let(:fixed_result) do
    StrengthService.decide_best(strengths,
                                result)
  end
  context 'has 2 results & 1 of them is best' do
    let(:strengths) { [8, 0] }
    let(:result) do
      [
        {
          "card": 'H1 H2 H3 H4 H5',
          "hand": 'ストレートフラッシュ',
          "best": false
        },
        {
          "card": 'S1 D3 H6 C9 D13',
          "hand": 'ハイカード',
          "best": false
        }
      ]
    end
    it '1st result is best' do
      expect(fixed_result[0][:best]).to eq true
    end
  end

  context 'has 3 results & 2 of them are best' do
    let(:strengths) { [7, 2, 7] }
    let(:result) do
      [
        {
          "card": 'S1 C1 H1 D1 D10',
          "hand": 'フォー・オブ・ア・カインド',
          "best": false
        },
        {
          "card": 'S1 C1 H4 D4 H9',
          "hand": 'ツーペア',
          "best": false
        },
        {
          "card": 'S13 H13 C13 D1 D13',
          "hand": 'フォー・オブ・ア・カインド',
          "best": false
        }
      ]
    end
    it '1st result is best' do
      expect(fixed_result[0][:best]).to eq true
    end
    it '3rd result is best' do
      expect(fixed_result[2][:best]).to eq true
    end
  end
end
