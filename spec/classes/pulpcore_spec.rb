require 'spec_helper'

describe 'pulpcore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('python3-pulpcore') }
      it { is_expected.to contain_concat__fragment('base').without_content(/REMOTE_USER_ENVIRON_NAME/) }
      it { is_expected.to contain_class('postgresql::server') }
      it { is_expected.to contain_postgresql__server__db('pulpcore') }

      context 'with a plugin' do
        let(:pre_condition) { "pulpcore::plugin { 'myplugin': }" }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('myplugin')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end
      end

      context 'with external postgresql' do
        let :params do
          {
            postgresql_db_host: '192.0.2.222',
            postgresql_manage_db: false,
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.not_to contain_class('postgresql::server')
          is_expected.not_to contain_postgresql__server__db('pulpcore')
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{'HOST': '192.0.2.222'})
        end
      end
    end
  end
end
