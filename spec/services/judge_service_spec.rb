require 'rails_helper'

RSpec.describe JudgeService do
  include JudgeService

  describe 'String request' do
    describe 'Judge hunds' do
      subject { JudgeService.search_hands(cards)[:name] }

      context 'all the same suit & 5 straight number' do
        let(:cards) { 'H1 H2 H3 H4 H5' }
        it { is_expected.to eq 'ストレートフラッシュ' }
      end

      context '4 cards with the same number' do
        let(:cards) { 'C1 D1 H1 S1 H7' }
        it { is_expected.to eq 'フォー・オブ・ア・カインド' }
      end

      context '3 cards with the same number & 2 other cards with the same number' do
        let(:cards) { 'C3 D3 H3 S10 D10' }
        it { is_expected.to eq 'フルハウス' }
      end

      context 'all the same suit' do
        let(:cards) { 'D2 D3 D6 D8 D13' }
        it { is_expected.to eq 'フラッシュ' }
      end

      context '5 straight number' do
        let(:cards) { 'C8 H9 D10 S11 H12' }
        it { is_expected.to eq 'ストレート' }
      end

      context '3 cards with the same number' do
        let(:cards) { 'C6 H6 D6 C1 S13' }
        it { is_expected.to eq 'スリー・オブ・ア・カインド' }
      end

      context '2 cards with the same number & other 2 cards with the same number' do
        let(:cards) { 'C2 H2 S10 S13 D10' }
        it { is_expected.to eq 'ツーペア' }
      end

      context '2 cards with the same number' do
        let(:cards) { 'C1 D1 S2 H5 S12' }
        it { is_expected.to eq 'ワンペア' }
      end

      context 'no hund' do
        let(:cards) { 'H1 D3 S8 C4 D11' }
        it { is_expected.to eq 'ハイカード' }
      end
    end
  end
end
