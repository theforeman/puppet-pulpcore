require 'spec_helper_acceptance'

describe 'Pulp 2 content routes' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'pulpcore':
      use_pulp2_file_content_route => true,
      } 
      include pulpcore::plugin::certguard
      include pulpcore::plugin::container
      include pulpcore::plugin::deb
      class { 'pulpcore::plugin::rpm':
        use_pulp2_content_route => true,
      }
      PUPPET
    end
  end

  include_examples 'the default pulpcore application'

  describe file('/etc/pulp/settings.py') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match(/^TOKEN_AUTH_DISABLED=True$/) }
  end
end
