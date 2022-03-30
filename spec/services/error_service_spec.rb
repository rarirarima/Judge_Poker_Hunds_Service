require 'rails_helper'

RSpec.describe ErrorService do
  include ErrorService

  describe 'error' do
    subject { ErrorService.process_errors(cards) }

    context 'no card' do
      let(:cards) { '' }
      it { is_expected.to eq 'カードが入力されていません。' }
    end

    context 'nil card' do
      let(:cards) { nil }
      it { is_expected.to eq 'カードが入力されていません。' }
    end

    context 'less than 5 cards' do
      let(:cards) { 'H2 S2 C3 D4' }
      it { is_expected.to eq '5つのカード指定文字を半角スペース区切りで入力してください。' }
    end

    context 'more than 5 cards' do
      let(:cards) { 'D2 S5 H1 C3 S9 S13' }
      it { is_expected.to eq '5つのカード指定文字を半角スペース区切りで入力してください。' }
    end

    context 'the suit of 1st card is lowercase' do
      let(:cards) { 's1 S2 C8 D10 H13' }
      it { is_expected.to eq ['1番目のカード指定文字(s1)が不正です。'] }
    end

    context 'the suit of all cards is lowercase' do
      let(:cards) { 'd1 c4 h13 s12 d5' }
      it {
        is_expected.to eq ['1番目のカード指定文字(d1)が不正です。', '2番目のカード指定文字(c4)が不正です。',
                           '3番目のカード指定文字(h13)が不正です。', '4番目のカード指定文字(s12)が不正です。',
                           '5番目のカード指定文字(d5)が不正です。']
      }
    end

    context 'the suit of 1st card is incorrect' do
      let(:cards) { 'X1 S2 C8 D10 H13' }
      it { is_expected.to eq ['1番目のカード指定文字(X1)が不正です。'] }
    end

    context 'the suit of all cards is incorrect' do
      let(:cards) { 'V2 W3 X7 Y8 Z13' }
      it {
        is_expected.to eq ['1番目のカード指定文字(V2)が不正です。', '2番目のカード指定文字(W3)が不正です。',
                           '3番目のカード指定文字(X7)が不正です。', '4番目のカード指定文字(Y8)が不正です。',
                           '5番目のカード指定文字(Z13)が不正です。']
      }
    end

    context 'the number of 1st card is incorrect' do
      let(:cards) { 'C99 D1 H3 D4 H5' }
      it { is_expected.to eq ['1番目のカード指定文字(C99)が不正です。'] }
    end

    context 'the number of all cards is incorrect' do
      let(:cards) { 'C0 D14 H99 S100 H10000' }
      it {
        is_expected.to eq ['1番目のカード指定文字(C0)が不正です。', '2番目のカード指定文字(D14)が不正です。',
                           '3番目のカード指定文字(H99)が不正です。', '4番目のカード指定文字(S100)が不正です。',
                           '5番目のカード指定文字(H10000)が不正です。']
      }
    end

    context '2 duplicate cards' do
      let(:cards) { 'D3 C8 S10 C8 D3' }
      it { is_expected.to eq 'カードが重複しています。' }
    end

    context '5 duplicate cards' do
      let(:cards) { 'S7 S7 S7 S7 S7' }
      it { is_expected.to eq 'カードが重複しています。' }
    end
  end
end
