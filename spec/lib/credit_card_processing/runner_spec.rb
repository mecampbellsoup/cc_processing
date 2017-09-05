require 'spec_helper'

module CreditCardProcessing
  RSpec.describe Runner do
    let(:input_file_path) { File.expand_path("../../../fixtures/input.txt", __FILE__) }
    let(:inputs) { File.read(input_file_path) }
    subject(:runner) { described_class.new(inputs) }

    describe "#summarize" do
      subject { runner.summarize }

      let(:output_file_path) { File.expand_path("../../../fixtures/output.txt", __FILE__) }
      let(:output) { File.read(output_file_path).split("\n") }

      it 'returns a list of the net credit card balances' do
        expect(subject).to eq(output)
      end
    end
  end
end
