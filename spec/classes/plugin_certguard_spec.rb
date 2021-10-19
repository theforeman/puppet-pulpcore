require 'spec_helper'

describe 'pulpcore::plugin::certguard' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('python3-subscription-manager-rhsm').with_ensure('present') }
      it { is_expected.to contain_package('pulpcore-plugin(certguard)') }
      it { is_expected.to contain_pulpcore__plugin('certguard') }

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('certguard')
            .that_requires('Package[python3-subscription-manager-rhsm]')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end
      end
    end
  end
end
