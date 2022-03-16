require 'spec_helper_acceptance'

describe 'basic installation' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include pulpcore
      PUPPET
    end
  end

  include_examples 'the default pulpcore application'

  describe command("PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings") do
    its(:exit_status) { is_expected.to eq 0 }
  end
end

describe 'with content cache enabled' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore':
        cache_enabled => true,
      }
      PUPPET
    end
  end

  include_examples 'the default pulpcore application'

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
end
