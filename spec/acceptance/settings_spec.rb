require 'spec_helper_acceptance'

describe 'TELEMETRY setting' do
  context 'default TELEMETRY' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^# TELEMETRY = False$/) }
    end
  end

  context 'TELEMETRY disabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          telemetry => false,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^TELEMETRY = False$/) }
    end
  end

  context 'TELEMETRY enabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          telemetry => true,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^TELEMETRY = True$/) }
    end
  end
end
