class WhatsappIdentifierService
  def initialize(phone_number)
    @phone_number = phone_number.to_s
  end

  def generate(should_mask = false)
    return '' if @phone_number.blank?

    if should_mask
      generate_masked_identifier
    else
      generate_regular_identifier
    end
  end

  private

  def generate_regular_identifier
    # Remove any non-digit characters and get last 6 digits
    digits = @phone_number.gsub(/\D/, '')
    last_digits = digits.last(6)
    
    "WA-#{last_digits}"
  end

  def generate_masked_identifier
    # Remove any non-digit characters and get last 3 digits
    digits = @phone_number.gsub(/\D/, '')
    last_digits = digits.last(3)
    
    # For masked identifiers, we show fewer digits
    "WA-***#{last_digits}"
  end
end
