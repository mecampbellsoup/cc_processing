require 'spec_helper'

module CreditCardProcessing
  RSpec.describe CreditCard do
    subject(:credit_card) { described_class.new(cardholder, card_number, limit) }
    let(:cardholder) { 'Bob Smith' }
    let(:card_number) { Luhnacy.generate(10) }
    let(:limit) { rand(0 .. 10_000) }

    describe "#save" do
      context 'when the Luhn 10 card number validation fails' do
        let(:card_number) { Luhnacy.generate(10, invalid: true) }

        it 'returns false' do
          expect(subject.save).to eq false
        end

        it 'does not add the card to the list of all cards' do
          expect { subject.save }.to_not change { described_class.all.count }
        end

        it 'marks the card as invalid' do
          subject.save
          expect(subject.valid?).to eq false
        end
      end

      context 'when the Luhn 10 card number validation passes' do
        before { expect(Luhnacy.valid?(card_number)).to eq true }

        it 'returns true' do
          expect(subject.save).to eq true
        end

        it 'adds the card to the list of all cards' do
          expect(described_class.all).to eq []
          subject.save
          expect(described_class.all).to eq [credit_card]
        end

        it 'marks the card as valid' do
          subject.save
          expect(subject.valid?).to eq true
        end
      end
    end

    describe "#credit" do
      subject { credit_card.credit(amount) }

      context 'when the credit card is not valid' do
        let(:card_number) { Luhnacy.generate(10, invalid: true) }
        let(:amount) { 100 }

        it 'ignores the transaction' do
          expect { subject }.to_not change { credit_card.balance }
        end
      end

      context 'when the credited amount would not decrease the card balance below 0' do
        let(:amount) { credit_card.balance - 1 }

        it 'lowers the balance of the card by the amount' do
          expect { subject }.to change { credit_card.balance }.by(-1 * amount)
        end
      end

      context 'when the credited amount would decrease the card balance below 0' do
        let(:amount) { credit_card.balance + 1 }

        it 'gives the card a negative balance' do
          expect { subject }.to change { credit_card.balance }.to(-1)
        end
      end
    end

    describe "#charge" do
      subject { credit_card.charge(amount) }

      context 'when the charged amount would raise the card balance over its limit' do
        let(:amount) { (credit_card.limit - credit_card.balance) + 1 }

        # NOTE: 'does not increase card balance' means that tx is ignored.
        it 'does not increase the card balance' do
          expect { subject }.to_not change { credit_card.balance }
        end
      end

      context 'when the charged amount would not raise the card balance over its limit' do
        let(:amount) { credit_card.limit - credit_card.balance }

        it 'increases the card balance by the charged amount' do
          expect { subject }.to change { credit_card.balance }.by(amount)
        end
      end
    end
  end
end
