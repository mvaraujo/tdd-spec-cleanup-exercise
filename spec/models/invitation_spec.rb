require 'rails_helper'

RSpec.describe Invitation do
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:team) }

  context 'user' do
    let(:invitation) { build :invitation }

    context 'after valid save' do
      before { invitation.save }

      it { expect(invitation.user).to be_invited }
    end

    context 'after invalid save' do
      before do
        invitation.team = nil
        invitation.save
      end

      it { expect(invitation.user).not_to be_invited }
    end
  end

  context 'log_statement' do
    let(:invitation) { build :invitation }

    context 'when valid' do
      it { expect(invitation.event_log_statement).to include(invitation.team.name) }
      it { expect(invitation.event_log_statement).to include(invitation.user.email) }

      context 'when not saved' do
        it { expect(invitation.event_log_statement).to include('PENDING') }
      end

      context 'when saved' do
        before { invitation.save }

        it { expect(invitation.event_log_statement).not_to include('PENDING') }
      end
    end

    context 'when invalid' do
      before { invitation.user = nil }

      it { expect(invitation.event_log_statement).to include('INVALID') }
    end
  end
end
