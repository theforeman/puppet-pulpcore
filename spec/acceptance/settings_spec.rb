require 'spec_helper_acceptance'

describe 'ANALYTICS setting' do
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

describe 'AUTHENTICATION_BACKENDS setting' do
  context 'default AUTHENTICATION_BACKENDS' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to include('AUTHENTICATION_BACKENDS = ["pulpcore.app.authentication.PulpNoCreateRemoteUserBackend"]') }
    end
  end

  context 'AUTHENTICATION_BACKENDS set' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          authentication_backends => [
            'django.contrib.auth.backends.ModelBackend',
            'pulpcore.app.authentication.PulpNoCreateRemoteUserBackend',
          ],
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to include('AUTHENTICATION_BACKENDS = ["django.contrib.auth.backends.ModelBackend", "pulpcore.app.authentication.PulpNoCreateRemoteUserBackend"]') }
    end
  end
end

describe 'REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES setting' do
  context 'default REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include pulpcore
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to include <<~EXPECTED
          REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES = (
              'rest_framework.authentication.SessionAuthentication',
              'pulpcore.app.authentication.PulpRemoteUserAuthentication',
          )
        EXPECTED
      end
    end
  end

  context 'REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES set' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          rest_framework_default_authentication_classes => [
            'rest_framework.authentication.BasicAuthentication',
            'rest_framework.authentication.SessionAuthentication',
            'pulpcore.app.authentication.PulpRemoteUserAuthentication',
          ],
        }
        PUPPET
      end
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) do
        is_expected.to include <<~EXPECTED
          REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES = (
              'rest_framework.authentication.BasicAuthentication',
              'rest_framework.authentication.SessionAuthentication',
              'pulpcore.app.authentication.PulpRemoteUserAuthentication',
          )
        EXPECTED
      end
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
