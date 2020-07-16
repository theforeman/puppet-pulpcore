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

    include pulpcore
    include pulpcore::plugin::certguard
    include pulpcore::plugin::container
    include pulpcore::plugin::deb
    include pulpcore::plugin::file
    include pulpcore::plugin::migration
    include pulpcore::plugin::rpm
    PUPPET
  }

  it_behaves_like 'a idempotent resource'

  describe file('/etc/pulp/settings.py') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match(/^TOKEN_AUTH_DISABLED=True$/) }
  end

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

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe command("curl -s http://#{host_inventory['fqdn']}/pulp/api/v3/status/ -w '%{response_code}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("200") }
    its(:exit_status) { is_expected.to eq 0 }
  end

end
