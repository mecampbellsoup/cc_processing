require 'spec_helper'

RSpec.describe "credit_card_processing executable" do
  let(:executable) { "bin/credit_card_processing #{input_file_path}" }
  let(:root) { File.expand_path("../../..", __FILE__) }
  subject { Dir.chdir(root) { system(executable) } }

  let(:input_file_path) { File.expand_path("../../fixtures/input.txt", __FILE__) }
  let(:summary_file_path) { File.expand_path("../../fixtures/output.txt", __FILE__) }
  let(:summary) { File.read(summary_file_path) }

  it 'prints the summary to stdout' do
    expect { subject }.to output(summary).to_stdout_from_any_process
  end
end
