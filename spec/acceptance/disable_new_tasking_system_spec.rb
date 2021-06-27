require 'spec_helper_acceptance'

describe 'change configuration from postgresql tasking system to rq tasking system', :order => :defined do
  certdir = '/etc/pulpcore-certs'

  context 'initial configuration with newer postgresql tasking system' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          worker_count          => 1,
          use_rq_tasking_system => false,
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
  
    describe file('/etc/systemd/system/pulpcore-resource-manager.service') do
      it { is_expected.not_to exist }
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
  
    describe command("PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings") do
      its(:stdout) { is_expected.to match(/^USE_NEW_WORKER_TYPE = True/) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  
    describe command("DJANGO_SETTINGS_MODULE=pulpcore.app.settings PULP_SETTINGS=/etc/pulp/settings.py rq info -c pulpcore.rqconfig") do
      its(:stdout) { is_expected.to match(/^0 workers, /) }
      its(:stdout) { is_expected.not_to match(/^resource-manager /) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
  
  context 'reconfigure pulpcore to use older rq worker tasking system' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          worker_count          => 1,
          use_rq_tasking_system => true,
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
  
    describe file('/etc/systemd/system/pulpcore-resource-manager.service') do
      it { is_expected.to exist }
    end
  
    describe service('pulpcore-resource-manager') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
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
  
    describe command("PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings") do
      its(:stdout) { is_expected.to match(/^USE_NEW_WORKER_TYPE = False/) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  
    describe command("DJANGO_SETTINGS_MODULE=pulpcore.app.settings PULP_SETTINGS=/etc/pulp/settings.py rq info -c pulpcore.rqconfig") do
      its(:stdout) { is_expected.to match(/^2 workers, /) }
      its(:stdout) { is_expected.to match(/^resource-manager /) }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
