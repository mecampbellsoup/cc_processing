require 'luhnacy'

module CreditCardProcessing
  class CreditCard
    @@cards = []

    class << self
      def find(cardholder)
        all.detect { |card| card.cardholder == cardholder }
      end

      def all
        @@cards
      end
      alias_method :cards, :all
    end

    attr_reader :limit, :balance, :cardholder

    def initialize(cardholder, card_number, limit)
      @cardholder = cardholder
      @card_number = card_number
      @limit = CreditCardProcessing.cast_amount(limit)
      @balance = 0
    end

    def save
      if valid?
        self.class.cards << self
        true
      else
        false
      end
    end

    def credit(amount)
      @balance -= amount if valid?
    end

    def charge(amount)
      if amount > remaining_limit
        # ignore this charge
        nil
      else
        # process this charge
        @balance += amount
      end if valid?
    end

    def valid?
      Luhnacy.valid?(@card_number)
    end

    private

    def remaining_limit
      limit - balance
    end
  end
end
