# frozen_string_literal: true
lib_path = File.expand_path('../../lib/credit_card_processing.rb', __FILE__)
require lib_path
require 'rspec'
require 'pry'

RSpec.configure do |config|
  config.before(:each) { CreditCardProcessing::CreditCard.cards.clear }
end
