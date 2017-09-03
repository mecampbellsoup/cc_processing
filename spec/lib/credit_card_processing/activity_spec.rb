require 'spec_helper'

RSpec.describe CreditCardProcessing::Activity do
  subject(:activity) { described_class.new(activity_string) }

  describe "#save" do
    subject { activity.save }

    context 'adding a credit card' do
      let(:activity_string) { "Add Tom #{card_number} $1000\n" }

      context 'when the card is valid' do
        let(:card_number) { Luhnacy.generate(10) }

        it { is_expected.to eq true }

        it 'adds the new card to the list of all cards' do
          expect { subject }.to change { CreditCardProcessing::CreditCard.all.count }.by(1)
        end
      end
    end

    context 'charging a card' do
      let(:activity_string) { "Charge Tom $500\n" }

      context 'when the person being charged has a credit card' do
        let(:card_number) { Luhnacy.generate(10) }

        before do
          CreditCardProcessing::Activity.new(
            "Add Tom #{card_number} $1000\n"
          ).save
        end

        it 'charges the card held by the person named in the string' do
          credit_card = CreditCardProcessing::CreditCard.all.first
          expect { subject }.to change { credit_card.balance }.by(500)
        end
      end
    end

    context 'crediting a card' do
      let(:activity_string) { "Credit Quincy $200\n" }
    end
  end
end
