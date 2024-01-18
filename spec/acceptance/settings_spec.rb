require 'spec_helper_acceptance'

describe 'ANALYTICS setting' do
  context 'default ANALYTICS' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^# ANALYTICS = False$/) }
    end
  end

  context 'ANALYTICS disabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          analytics => false,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^ANALYTICS = False$/) }
    end
  end

  context 'ANALYTICS enabled' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          analytics => true,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^ANALYTICS = True$/) }
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

describe 'IMPORT_WORKERS_PERCENT setting' do
  context 'default IMPORT_WORKERS_PERCENT' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^# IMPORT_WORKERS_PERCENT = 100$/) }
    end
  end

  context 'IMPORT_WORKERS_PERCENT set' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          import_workers_percent => 42,
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(/^IMPORT_WORKERS_PERCENT = 42$/) }
    end
  end
end
