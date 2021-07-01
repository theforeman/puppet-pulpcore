require 'spec_helper_acceptance'

describe 'basic installation' do
  certdir = '/etc/pulpcore-certs'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore':
        worker_count => 2,
      }
      PUPPET
    end
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

  describe service('pulpcore-worker@3') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
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
    its(:response_code) { is_expected.to eq(200) }
    its(:body) { is_expected.not_to contain('artifacts_list') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/",
                        cacert: "#{certdir}/ca-cert.pem", key: "#{certdir}/client-key.pem", cert: "#{certdir}/client-cert.pem") do
    its(:response_code) { is_expected.to eq(200) }
    its(:body) { is_expected.to contain('artifacts_list') }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe command("PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings") do
    its(:stdout) { is_expected.to match(/^USE_NEW_WORKER_TYPE = True/) }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe service('rh-redis5-redis'), if: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
    it { is_expected.not_to be_running }
    it { is_expected.not_to be_enabled }
  end

  describe service('redis'), unless: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
    it { is_expected.not_to be_running }
    it { is_expected.not_to be_enabled }
  end

  describe command("DJANGO_SETTINGS_MODULE=pulpcore.app.settings PULP_SETTINGS=/etc/pulp/settings.py rq info -c pulpcore.rqconfig") do
    its(:stdout) { is_expected.not_to match(/Connection refused/) }
    its(:exit_status) { is_expected.to eq 1 }
  end
end

describe 'reducing worker count' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore':
        worker_count => 1,
      }
      PUPPET
    end
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

  describe service('pulpcore-worker@2') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

end

describe 'with content cache enabled' do
  certdir = '/etc/pulpcore-certs'

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore':
        cache_enabled => true,
      }
      PUPPET
    end
  end

  describe service('httpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('pulpcore-content') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe port(6379) do
    it { is_expected.to be_listening }
  end

  describe service('rh-redis5-redis'), if: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('redis'), unless: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe command("DJANGO_SETTINGS_MODULE=pulpcore.app.settings PULP_SETTINGS=/etc/pulp/settings.py rq info -c pulpcore.rqconfig") do
    its(:stdout) { is_expected.to match(/^0 workers, /) }
    its(:stdout) { is_expected.not_to match(/^resource-manager /) }
    its(:exit_status) { is_expected.to eq 0 }
  end

  describe curl_command("https://#{host_inventory['fqdn']}/pulp/api/v3/status/", cacert: "#{certdir}/ca-cert.pem") do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
