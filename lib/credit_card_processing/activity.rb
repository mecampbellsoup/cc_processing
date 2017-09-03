module CreditCardProcessing
  class Activity
    def initialize(activity_string)
      @activity_string = activity_string
    end

    def save
      activity.save
    end

    def cardholder
      activity_attributes.first
    end

    private

    def activity
      activity_type.new(*activity_attributes)
    end

    def activity_chunks
      @activity_string.split
    end

    def activity_attributes
      activity_chunks[1 .. -1]
    end

    def activity_type
      case action
      when /Add/
        CreditCard
      when /Charge/
        CreditCard::Charge
      when /Credit/
        CreditCard::Credit
      end
    end

    def action
      activity_chunks.first
    end
  end
end
