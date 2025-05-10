class WhatsappIdentifierService
  def initialize(phone_number)
    @phone_number = phone_number.to_s
  end

  def generate
    return '' if @phone_number.blank?

    # Remove any non-digit characters and get last 6 digits
    digits = @phone_number.gsub(/\D/, '')
    last_digits = digits.last(6)
    
    "WA-#{last_digits}"
  end
end
