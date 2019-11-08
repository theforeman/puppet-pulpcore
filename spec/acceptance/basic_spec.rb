require 'spec_helper_acceptance'

describe 'basic installation' do
  let(:pp) { 'include pulpcore' }

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
