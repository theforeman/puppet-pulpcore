require 'spec_helper'

describe 'pulpcore::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_anchor('pulpcore::repo')
        is_expected.to contain_file('/etc/yum.repos.d/pulpcore.repo')
          .with_content(%r{^baseurl=https://yum.theforeman.org/pulpcore/\d+\.\d+/el\d+/\$basearch$})
          .that_comes_before('Anchor[pulpcore::repo]')
      end
    end
  end
end
