require 'spec_helper_acceptance'

describe 'installation of server with cli' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include pulpcore
      class { 'pulpcore::cli':
        pulpcore_url => "https://${facts['fqdn']}/",
        cert         => "/etc/pulpcore-certs/client-cert.pem",
        key          => "/etc/pulpcore-certs/client-key.pem",
      }
      PUPPET
    end
  end

  include_examples 'the default pulpcore application'

  describe command("pulp config validate --location /etc/pulp/cli.toml") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/valid pulp-cli config/) }
    its(:stderr) { is_expected.to eq '' }
  end

  describe command("REQUESTS_CA_BUNDLE=/etc/pulpcore-certs/ca-cert.pem pulp status") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/versions/) }
    its(:stderr) { is_expected.not_to match(/Error/) }
    its(:stderr) { is_expected.to eq '' }
  end

  describe command("REQUESTS_CA_BUNDLE=/etc/pulpcore-certs/ca-cert.pem pulp user list") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/admin/) }
    its(:stderr) { is_expected.not_to match(/Error/) }
    its(:stderr) { is_expected.to eq '' }
  end
end

describe 'installation of cli only' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include pulpcore::cli
      PUPPET
    end
  end

  describe command("pulp config validate --location /etc/pulp/cli.toml") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/valid pulp-cli config/) }
    its(:stderr) { is_expected.to eq '' }
  end
end

describe 'installation of cli only with password' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore::cli':
        pulpcore_url => "https://${facts['fqdn']}/",
        username     => "admin",
        password     => "changeme",
      }
      PUPPET
    end
  end

  describe command("pulp config validate --location /etc/pulp/cli.toml") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/valid pulp-cli config/) }
    its(:stderr) { is_expected.to eq '' }
  end

  describe command("pulp config validate --location /root/.config/pulp/cli.toml") do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match(/valid pulp-cli config/) }
    its(:stderr) { is_expected.to eq '' }
  end
end
