require 'rails_helper'

RSpec.describe WhatsappIdentifierService do
  context 'when generating identifiers' do
    it 'returns empty string for blank phone numbers' do
      service = described_class.new('')
      expect(service.generate).to eq('')
    end

    it 'returns last 6 digits with WA prefix for regular mode' do
      service = described_class.new('+1234567890')
      expect(service.generate).to eq('WA-567890')
    end

    it 'returns masked identifier with last 3 digits for masked mode' do
      service = described_class.new('+1234567890')
      expect(service.generate(true)).to eq('WA-***890')
    end

    it 'handles phone numbers with non-digit characters' do
      service = described_class.new('+1 (234) 567-890')
      expect(service.generate).to eq('WA-567890')
      expect(service.generate(true)).to eq('WA-***890')
    end

    it 'handles short phone numbers correctly' do
      service = described_class.new('+12345')
      expect(service.generate).to eq('WA-12345')
      expect(service.generate(true)).to eq('WA-**345')
    end
  end
end
