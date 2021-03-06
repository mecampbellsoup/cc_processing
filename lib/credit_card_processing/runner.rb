module CreditCardProcessing
  class Runner
    def initialize(inputs)
      @inputs = inputs
      @cardholder_names = []
    end

    def summarize
      process_transactions!

      sorted_cardholder_names = @cardholder_names.sort
      sorted_cardholder_names.map { |cardholder| summary_for(cardholder) }
    end

    private

    def summary_for(cardholder)
      credit_card = CreditCardProcessing::CreditCard.find(cardholder)

      if credit_card
        "#{cardholder}: $#{credit_card.balance}"
      else
        "#{cardholder}: error"
      end
    end

    def process_transactions!
      @inputs.each_line do |line|
        activity = Activity.new(line)
        activity.save
        # Array#| joins the two arrays, excluding any duplicates.
        @cardholder_names |= [activity.cardholder]
      end
    end
  end
end
