require 'spec_helper_acceptance'

describe 'configures pulpcore worker count', :order => :defined do
  context 'initial configuration with 2 pulpcore workers' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          worker_count => 2,
        }
        PUPPET
      end
    end

    [1,2].each do |i|
      describe service("pulpcore-worker@#{i}") do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end
    end

    describe service('pulpcore-worker@3') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end

  context 'reconfigure to use 1 pulpcore worker' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'pulpcore':
          worker_count => 1,
        }
        PUPPET
      end
    end

    describe service('pulpcore-worker@1') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    [2,3].each do |i|
      describe service("pulpcore-worker@#{i}") do
        it { is_expected.not_to be_enabled }
        it { is_expected.not_to be_running }
      end
    end
  end
end
