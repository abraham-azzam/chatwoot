# frozen_string_literal: true

require 'rails_helper'

require Rails.root.join 'spec/models/concerns/avatarable_shared.rb'

RSpec.describe Contact do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:account_id) }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:account) }
    it { is_expected.to have_many(:conversations).dependent(:destroy_async) }
  end

  describe 'concerns' do
    it_behaves_like 'avatarable'
  end

  context 'when prepare contact attributes before validation' do
    it 'sets email to lowercase' do
      contact = create(:contact, email: 'Test@test.com')
      expect(contact.email).to eq('test@test.com')
      expect(contact.contact_type).to eq('lead')
    end

    it 'sets email to nil when empty string' do
      contact = create(:contact, email: '')
      expect(contact.email).to be_nil
      expect(contact.contact_type).to eq('visitor')
    end

    it 'sets custom_attributes to {} when nil' do
      contact = create(:contact, custom_attributes: nil)
      expect(contact.custom_attributes).to eq({})
    end

    it 'sets custom_attributes to {} when empty string' do
      contact = create(:contact, custom_attributes: '')
      expect(contact.custom_attributes).to eq({})
    end

    it 'sets additional_attributes to {} when nil' do
      contact = create(:contact, additional_attributes: nil)
      expect(contact.additional_attributes).to eq({})
    end

    it 'sets additional_attributes to {} when empty string' do
      contact = create(:contact, additional_attributes: '')
      expect(contact.additional_attributes).to eq({})
    end
  end

  context 'when phone number format' do
    it 'will throw error for existing invalid phone number' do
      contact = create(:contact)
      expect { contact.update!(phone_number: '123456789') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'updates phone number when adding valid phone number' do
      contact = create(:contact)
      expect(contact.update!(phone_number: '+12312312321')).to be true
      expect(contact.phone_number).to eq '+12312312321'
    end
  end

  context 'when email format' do
    it 'will throw error for existing invalid email' do
      contact = create(:contact)
      expect { contact.update!(email: '<2324234234') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'updates email when adding valid email' do
      contact = create(:contact)
      expect(contact.update!(email: 'test@test.com')).to be true
      expect(contact.email).to eq 'test@test.com'
    end
  end

  context 'when city and country code passed in additional attributes' do
    it 'updates location and country code' do
      contact = create(:contact, additional_attributes: { city: 'New York', country: 'US' })
      expect(contact.location).to eq 'New York'
      expect(contact.country_code).to eq 'US'
    end
  end

  context 'when a contact is created' do
    it 'has contact type "visitor" by default' do
      contact = create(:contact)
      expect(contact.contact_type).to eq 'visitor'
    end

    it 'has contact type "lead" when email is present' do
      contact = create(:contact, email: 'test@test.com')
      expect(contact.contact_type).to eq 'lead'
    end

    it 'has contact type "lead" when contacted through a social channel' do
      contact = create(:contact, additional_attributes: { social_facebook_user_id: '123' })
      expect(contact.contact_type).to eq 'lead'
    end
  end

  describe 'permissions and masking' do
    let(:account) { create(:account) }
    let(:contact) { create(:contact, account: account, phone_number: '+1234567890', name: 'John Doe') }
    let(:admin_user) { create(:user, account: account, role: :administrator) }
    let(:agent_user) { create(:user, account: account, role: :agent) }
    let(:agent_with_permissions) do
      user = create(:user, account: account, role: :agent)
      create(:custom_role, account: account, name: 'Agent with contact permissions', custom_permissions: ['contact_manage'])
      user.update!(custom_role: CustomRole.last)
      user
    end

    describe '#user_can_view_contact_details?' do
      it 'allows administrators to view contact details' do
        expect(contact.user_can_view_contact_details?(admin_user)).to be true
      end

      it 'allows agents with contact_manage permission to view details' do
        expect(contact.user_can_view_contact_details?(agent_with_permissions)).to be true
      end

      it 'allows agents participating in conversations to view details' do
        conversation = create(:conversation, account: account, contact: contact)
        create(:conversation_participant, conversation: conversation, user: agent_user)
        expect(contact.user_can_view_contact_details?(agent_user)).to be true
      end

      it 'denies access to agents without permissions or participation' do
        expect(contact.user_can_view_contact_details?(agent_user)).to be false
      end
    end

    describe '#masked_name' do
      it 'shows full name to administrators' do
        expect(contact.masked_name(admin_user)).to eq('John Doe')
      end

      it 'shows masked name to unauthorized agents' do
        expect(contact.masked_name(agent_user)).to eq('WA-***890')
      end

      it 'shows full name to authorized agents' do
        expect(contact.masked_name(agent_with_permissions)).to eq('John Doe')
      end
    end

    describe '#masked_phone_number' do
      it 'shows full number to administrators' do
        expect(contact.masked_phone_number(admin_user)).to eq('+1234567890')
      end

      it 'shows masked number to unauthorized agents' do
        expect(contact.masked_phone_number(agent_user)).to eq('+*******890')
      end

      it 'shows full number to authorized agents' do
        expect(contact.masked_phone_number(agent_with_permissions)).to eq('+1234567890')
      end
    end

    describe '#display_identifier' do
      before do
        allow(contact).to receive(:from_whatsapp_channel?).and_return(true)
      end

      it 'shows regular identifier to administrators' do
        expect(contact.display_identifier(admin_user)).to eq('WA-567890')
      end

      it 'shows masked identifier to unauthorized agents' do
        expect(contact.display_identifier(agent_user)).to eq('WA-***890')
      end

      it 'shows regular identifier to authorized agents' do
        expect(contact.display_identifier(agent_with_permissions)).to eq('WA-567890')
      end

      it 'returns name for non-whatsapp channels' do
        allow(contact).to receive(:from_whatsapp_channel?).and_return(false)
        expect(contact.display_identifier(agent_user)).to eq('John Doe')
      end
    end
  end
end
