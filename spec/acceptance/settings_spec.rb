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

describe 'HIDE_GUARDED_DISTRIBUTIONS setting' do
  context 'default HIDE_GUARDED_DISTRIBUTIONS' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^# HIDE_GUARDED_DISTRIBUTIONS = False$/) }
    end
  end

  context 'HIDE_GUARDED_DISTRIBUTIONS disabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          hide_guarded_distributions => false,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^HIDE_GUARDED_DISTRIBUTIONS = False$/) }
    end
  end

  context 'HIDE_GUARDED_DISTRIBUTIONS enabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          hide_guarded_distributions => true,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^HIDE_GUARDED_DISTRIBUTIONS = True$/) }
    end
  end
end
