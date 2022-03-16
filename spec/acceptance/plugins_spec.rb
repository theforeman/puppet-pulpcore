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
      if versioncmp(fact('os.release.major'), '8') >= 0 {
        include pulpcore::plugin::ostree
      }
      include pulpcore::plugin::python
      include pulpcore::plugin::rpm
      PUPPET
    end
  end

  include_examples 'the default pulpcore application'

  describe file('/etc/pulp/settings.py') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match(/^TOKEN_AUTH_DISABLED=True$/) }
  end
end
