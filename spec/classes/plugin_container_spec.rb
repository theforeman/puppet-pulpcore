require 'spec_helper'

describe 'pulpcore::plugin::container' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include pulpcore' }

      it 'configures the plugin' do
        is_expected.to compile.with_all_deps
        is_expected.to contain_pulpcore__plugin('container')
          .that_subscribes_to('Class[Pulpcore::Install]')
          .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        is_expected.to contain_package('pulpcore-plugin(container)')
        is_expected.to contain_concat__fragment('plugin-container').with_content("\n# container plugin settings\nTOKEN_AUTH_DISABLED=True")
        is_expected.to contain_pulpcore__apache__fragment('plugin-container')
        is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-plugin-container')
        is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-container')
      end
    end
  end
end
