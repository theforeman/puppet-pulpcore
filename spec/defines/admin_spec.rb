require 'spec_helper'

describe 'pulpcore::admin' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'help' }

      context 'with a fixed pulp_settings and user' do
        let(:params) do
          {
            pulp_settings: '/etc/pulpcore/settings.py',
            user: 'pulpcore',
          }
        end

        context 'default parameters' do
          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_exec('pulpcore-manager help')
              .with_user('pulpcore')
              .with_environment(['PULP_SETTINGS=/etc/pulpcore/settings.py'])
              .with_refreshonly(false)
              .with_unless(nil)
          end
        end

        context 'default parameters' do
          let(:params) do
            super().merge(
              command: 'migrate --noinput',
              refreshonly: true,
              unless: '/usr/bin/false',
            )
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_exec('pulpcore-manager migrate --noinput')
              .with_user('pulpcore')
              .with_environment(['PULP_SETTINGS=/etc/pulpcore/settings.py'])
              .with_refreshonly(true)
              .with_unless('/usr/bin/false')
          end
        end
      end

      context 'with inheritance' do
        let(:pre_condition) { 'include pulpcore' }

        context 'default parameters' do
          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_pulpcore__admin('help').with_pulp_settings('/etc/pulp/settings.py')
            is_expected.to contain_concat('pulpcore settings')
            is_expected.to contain_exec('pulpcore-manager help')
              .with_user('pulp')
              .with_environment(['PULP_SETTINGS=/etc/pulp/settings.py'])
              .with_refreshonly(false)
              .with_unless(nil)
              .that_requires('Concat[pulpcore settings]')
          end
        end
      end
    end
  end
end
