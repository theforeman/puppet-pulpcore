require 'spec_helper_acceptance'

describe 'basic installation' do
  let(:pp) {
    <<-PUPPET
    class { 'postgresql::globals':
      version              => '10',
      client_package_name  => 'rh-postgresql10-postgresql-syspaths',
      server_package_name  => 'rh-postgresql10-postgresql-server-syspaths',
      contrib_package_name => 'rh-postgresql10-postgresql-contrib-syspaths',
      service_name         => 'postgresql',
      datadir              => '/var/lib/pgsql/data',
      confdir              => '/var/lib/pgsql/data',
      bindir               => '/usr/bin',
    }
    include pulpcore
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

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe command("curl -s http://#{host_inventory['fqdn']}/pulp/api/v3/status/ -w '%{response_code}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("200") }
    its(:exit_status) { is_expected.to eq 0 }
  end

end
