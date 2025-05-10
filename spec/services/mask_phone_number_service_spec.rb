require 'rails_helper'

RSpec.describe MaskPhoneNumberService do
  context 'when masking phone numbers' do
    it 'returns empty string for blank phone numbers' do
      service = described_class.new('')
      expect(service.masked_number).to eq('')
    end

    it 'masks all but last 3 digits' do
      service = described_class.new('+1234567890')
      expect(service.masked_number).to eq('+*******890')
    end

    it 'preserves plus prefix in international numbers' do
      service = described_class.new('+44123456789')
      expect(service.masked_number).to eq('+********789')
    end

    it 'handles short phone numbers correctly' do
      service = described_class.new('+1234')
      expect(service.masked_number).to eq('+*234')
    end

    it 'handles phone numbers with formatting characters' do
      service = described_class.new('+1 (234) 567-890')
      expect(service.masked_number).to eq('+*******890')
    end
  end
end
