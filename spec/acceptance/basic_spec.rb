require 'spec_helper_acceptance'

describe 'basic installation' do
  let(:pp) {
    <<-PUPPET
    if $facts['os']['release']['major'] == '7' {
      class { 'postgresql::globals':
        version              => '12',
        client_package_name  => 'rh-postgresql12-postgresql-syspaths',
        server_package_name  => 'rh-postgresql12-postgresql-server-syspaths',
        contrib_package_name => 'rh-postgresql12-postgresql-contrib-syspaths',
        service_name         => 'postgresql',
        datadir              => '/var/lib/pgsql/data',
        confdir              => '/var/lib/pgsql/data',
        bindir               => '/usr/bin',
      }
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
    }

    class { 'pulpcore':
      worker_count => 2,
    }
    PUPPET
  }

  it_behaves_like 'a idempotent resource'

  describe service('httpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-api') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-content') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-resource-manager') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-worker@1') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-worker@3') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe command("curl -s http://#{host_inventory['fqdn']}/pulp/api/v3/status/ -w '%{response_code}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("200") }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe command("DJANGO_SETTINGS_MODULE=pulpcore.app.settings PULP_SETTINGS=/etc/pulp/settings.py python3-django-admin dumpdata auth.User") do
    its(:stdout) { is_expected.to match(/auth\.user/) }
    its(:exit_status) { is_expected.to eq 0 }
  end

end

describe 'reducing worker count' do
  let(:pp) {
    <<-PUPPET
    if $facts['os']['release']['major'] == '7' {
      class { 'postgresql::globals':
        version              => '12',
        client_package_name  => 'rh-postgresql12-postgresql-syspaths',
        server_package_name  => 'rh-postgresql12-postgresql-server-syspaths',
        contrib_package_name => 'rh-postgresql12-postgresql-contrib-syspaths',
        service_name         => 'postgresql',
        datadir              => '/var/lib/pgsql/data',
        confdir              => '/var/lib/pgsql/data',
        bindir               => '/usr/bin',
      }
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
    }

    class { 'pulpcore':
      worker_count => 1,
    }
    PUPPET
  }

  it_behaves_like 'a idempotent resource'

  describe service('httpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-api') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-content') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-resource-manager') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-worker@1') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-worker@2') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

end
