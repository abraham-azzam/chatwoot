class MaskPhoneNumberService
  def initialize(phone_number)
    @phone_number = phone_number&.strip
  end

  def masked_number
    return '' if @phone_number.blank?
    # Keep country code and last 4 digits, mask the rest
    visible_part = @phone_number.last(4)
    masked_part = '*' * (@phone_number.length - 4)
    "#{masked_part}#{visible_part}"
  end
end
