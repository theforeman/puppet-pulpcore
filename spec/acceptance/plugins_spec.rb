require 'spec_helper_acceptance'

describe 'Installation with all plugins' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include pulpcore
      include pulpcore::plugin::ansible
      include pulpcore::plugin::certguard
      include pulpcore::plugin::container
      include pulpcore::plugin::deb
      include pulpcore::plugin::file
      if fact('pulpcore_version') == '3.14' {
        include pulpcore::plugin::migration
      }
      if versioncmp(fact('pulpcore_version'), '3.15') >= 0 {
        if versioncmp(fact('os.release.major'), '8') >= 0 {
          include pulpcore::plugin::ostree
        }
        include pulpcore::plugin::python
      }
      include pulpcore::plugin::rpm
      PUPPET
    end
  end

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
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/status/", cacert: '/etc/pulpcore-certs/ca-cert.pem') do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end

end
