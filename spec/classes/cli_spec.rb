require 'spec_helper'

describe 'pulpcore::cli' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include pulpcore::cli' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('pulp-cli') }
    end
  end
end
