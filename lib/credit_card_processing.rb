require 'credit_card_processing/credit_card'
require 'credit_card_processing/credit_card/charge'
require 'credit_card_processing/credit_card/credit'
require 'credit_card_processing/activity'
require 'credit_card_processing/runner'

module CreditCardProcessing
  # Utility for casting "$AMOUNT" strings to integers
  #
  def self.cast_amount(amount)
    case amount
    when String
      Integer(amount.match(/\d+/)[0])
    when Integer
      amount
    end
  end
end
