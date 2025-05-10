class MaskPhoneNumberService
  def initialize(phone_number)
    @phone_number = phone_number.to_s
  end

  def masked_number
    return '' if @phone_number.blank?

    visible_digits = 3
    total_length = @phone_number.length
    mask_length = total_length - visible_digits
    
    return @phone_number if mask_length <= 0

    ('*' * mask_length) + @phone_number[-visible_digits..]
  end
end
