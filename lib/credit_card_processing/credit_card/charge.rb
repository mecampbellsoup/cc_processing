module CreditCardProcessing
  class CreditCard::Charge
    def initialize(cardholder, amount)
      @cardholder = cardholder
      @amount = CreditCardProcessing.cast_amount(amount)
    end

    def save
      valid? ? credit_card.charge(@amount) : false
    end

    private

    def valid?
      # We can attempt to credit a CC as long as that card is present.
      # CreditCard#valid? defines other validations
      !!credit_card
    end

    def credit_card
      CreditCardProcessing::CreditCard.find(@cardholder)
    end
  end
end
