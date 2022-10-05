shared_examples 'the default pulpcore application' do
  certdir = '/etc/pulpcore-certs'

  describe user('pulp') do
    it { is_expected.to exist }
    its(:uid) { is_expected.to be < 1000 }
  end

  describe group('pulp') do
    it { is_expected.to exist }
    its(:gid) { is_expected.to be < 1000 }
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

  describe service('pulpcore-worker@1') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/status/", cacert: "#{certdir}/ca-cert.pem") do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe command("PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager dumpdata auth.User") do
    its(:stdout) { is_expected.to match(/auth\.user/) }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/", cacert: "#{certdir}/ca-cert.pem") do
    # Requires authentication: https://github.com/pulp/pulpcore/issues/2340
    if(!['3.16', '3.17', '3.18', '3.19'].include?(ENV['BEAKER_FACTER_PULPCORE_VERSION']))
      its(:response_code) { is_expected.to eq(200) }
    else
      its(:response_code) { is_expected.to eq(403) }
    end
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/",
                        cacert: "#{certdir}/ca-cert.pem", key: "#{certdir}/client-key.pem", cert: "#{certdir}/client-cert.pem") do
    its(:response_code) { is_expected.to eq(200) }
    its(:body) { is_expected.to contain('artifacts') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/users/", cacert: "#{certdir}/ca-cert.pem") do
    its(:response_code) { is_expected.to eq(403) }
    its(:body) { is_expected.to contain('Authentication credentials were not provided.') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/users/",
                        cacert: "#{certdir}/ca-cert.pem", key: "#{certdir}/client-key.pem", cert: "#{certdir}/client-cert.pem") do
    its(:response_code) { is_expected.to eq(200) }
    its(:body) { is_expected.to contain('admin') }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
