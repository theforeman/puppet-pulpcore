require 'spec_helper'

describe 'pulpcore::plugin::container' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pulpcore__plugin('container') }
      it { is_expected.to contain_package('python3-pulp-container') }
      it { is_expected.to contain_concat__fragment('plugin-container').with_content("\n# container plugin settings\nTOKEN_AUTH_DISABLED=True") }

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('container')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end
      end
    end
  end
end
