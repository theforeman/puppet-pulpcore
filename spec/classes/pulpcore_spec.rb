require 'spec_helper'

describe 'pulpcore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { override_facts(os_facts, processors: {count: 1}, os: {selinux: {enabled: true}}) }

      context 'default params' do
        it { is_expected.to compile.with_all_deps }

        it 'installs' do
          is_expected.to contain_class('pulpcore::install')
          is_expected.to contain_package('python3-pulpcore')
          is_expected.to contain_package('pulpcore-selinux')
          is_expected.to contain_user('pulp').with_gid('pulp').with_home('/var/lib/pulp')
          is_expected.to contain_group('pulp')
        end

        it 'configures pulpcore' do
          is_expected.to contain_class('pulpcore::config')
          is_expected.to contain_concat('pulpcore settings').with_path('/etc/pulp/settings.py')
          is_expected.to contain_concat__fragment('base')
            .without_content(/sslmode/)
          is_expected.to contain_file('/etc/pulp')
          is_expected.to contain_file('/var/lib/pulp')
          is_expected.to contain_file('/var/lib/pulp/assets')
          is_expected.to contain_file('/var/lib/pulp/media')
          is_expected.to contain_file('/var/lib/pulp/docroot')
          is_expected.to contain_file('/var/lib/pulp/tmp')
          is_expected.to contain_file('/var/lib/pulp/upload')
        end

        it 'sets up static files' do
          is_expected.to contain_class('pulpcore::static')
          is_expected.to contain_file('/var/lib/pulp/assets')
          is_expected.to contain_pulpcore__admin('collectstatic --noinput')
          is_expected.to contain_exec('pulpcore-manager collectstatic --noinput')
        end

        it 'configures the database' do
          is_expected.to contain_class('pulpcore::database')
          is_expected.to contain_class('postgresql::server')
          is_expected.to contain_postgresql__server__db('pulpcore')
          is_expected.to contain_pulpcore__admin('migrate --noinput')
          is_expected.to contain_exec('pulpcore-manager migrate --noinput')
          is_expected.to contain_pulpcore__admin('reset-admin-password --random')
          is_expected.to contain_exec('pulpcore-manager reset-admin-password --random')
        end

        it 'configures apache' do
          is_expected.to contain_class('pulpcore::apache')
          is_expected.to contain_apache__vhost('pulpcore')
          is_expected.to contain_selinux__boolean('httpd_can_network_connect')
        end

        it 'configures services' do
          is_expected.to contain_class('pulpcore::service')
          is_expected.to contain_systemd__unit_file('pulpcore-resource-manager.service')
          is_expected.to contain_systemd__unit_file('pulpcore-worker@.service')
          is_expected.to contain_service("pulpcore-worker@1.service").with_ensure('running')
          is_expected.not_to contain_service("pulpcore-worker@2.service")
        end
      end

      context 'with worker_count set to 5' do
        let(:params) { { worker_count: 5 } }

        context 'with 6 workers from fact' do
          let(:facts) { super().merge(pulpcore_workers: (1..6).map { |n| "pulpcore-worker@#{n}.service" } ) }

          it 'is expected to reduce the workers to 5' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure('running')
                .with_enable('true')
            end
            is_expected.to contain_service('pulpcore-worker@6.service')
              .with_ensure('stopped')
              .with_enable('false')
          end
        end

        context 'with 4 workers from fact' do
          let(:facts) { super().merge(pulpcore_workers: (1..4).map { |n| "pulpcore-worker@#{n}.service" } ) }

          it 'is expected to increase the workers to 5' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure('running')
                .with_enable('true')
            end
            is_expected.not_to contain_service('pulpcore-worker@6.service')
          end
        end

        context 'with 0 workers from fact' do
          let(:facts) { super().merge(pulpcore_workers: {} ) }

          it 'is expected to enable 5 workers' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure('running')
                .with_enable('true')
            end
            is_expected.not_to contain_service('pulpcore-worker@6.service')
          end
        end

        context 'fact absent' do
          it 'is expected to enable 5 workers' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure('running')
                .with_enable('true')
            end
            is_expected.not_to contain_service('pulpcore-worker@6.service')
          end
        end
      end

      context 'without apache httpd' do
        let :params do
          {
            manage_apache: false,
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.not_to contain_file('/var/lib/pulp/docroot')
          is_expected.not_to contain_apache__vhost('pulpcore')
          is_expected.not_to contain_selinux__boolean('httpd_can_network_connect')
        end
      end

      context 'with a plugin' do
        let(:pre_condition) { "pulpcore::plugin { 'myplugin': }" }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('myplugin')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
          is_expected.to contain_package('python3-pulp-myplugin')
        end
      end

      context 'with the repo' do
        let(:pre_condition) { 'include pulpcore::repo' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('pulpcore::repo')
          is_expected.to contain_file('/etc/yum.repos.d/pulpcore.repo').that_notifies('Class[pulpcore::install]')
        end
      end

      context 'with custom ports' do
        let :params do
          {
            api_port: 24819,
            content_port: 24818,
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_selinux__port('pulpcore-api-port')
            .with_port(24819)
          is_expected.to contain_selinux__port('pulpcore-content-port')
            .with_port(24818)
          is_expected.to contain_systemd__unit_file('pulpcore-api.service')
            .with_content(%r{--bind '127.0.0.1:24819'})
          is_expected.to contain_systemd__unit_file('pulpcore-content.service')
            .with_content(%r{--bind '127.0.0.1:24818'})
          is_expected.to contain_apache__vhost('pulpcore')
            .with_proxy_pass([
              {
                'path'         => '/pulp/api/v3',
                'url'          => "http://127.0.0.1:24819/pulp/api/v3",
                'reverse_urls' => ["http://127.0.0.1:24819/pulp/api/v3"],
              },
              {
                'path'         => '/pulp/content',
                'url'          => "http://127.0.0.1:24818/pulp/content",
                'reverse_urls' => ["http://127.0.0.1:24818/pulp/content"],
              },
            ])
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

        context 'with SSL' do
          let :params do
            super().merge(
              postgresql_db_ssl: true,
              postgresql_db_ssl_require: true,
              postgresql_db_ssl_cert: '/etc/pki/katello/certs/pulpcore-database.crt',
              postgresql_db_ssl_key: '/etc/pki/katello/private/pulpcore-database.key',
              postgresql_db_ssl_root_ca: '/etc/pki/tls/certs/ca-bundle.crt',
            )
          end

          it do
            is_expected.to compile.with_all_deps
            verify_concat_fragment_contents(catalogue, 'base', [
              "            'sslmode': 'require',",
              "            'sslcert': '/etc/pki/katello/certs/pulpcore-database.crt',",
              "            'sslkey': '/etc/pki/katello/private/pulpcore-database.key',",
              "            'sslrootcert': '/etc/pki/tls/certs/ca-bundle.crt',",
            ])
          end
        end
      end

      context 'with allowed import paths' do
        let :params do
          {
            allowed_import_path: ['/test/path', '/test/path2'],
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{ALLOWED_IMPORT_PATHS = \["/test/path", "/test/path2"\]})

        end
      end

      context 'with empty allowed import paths' do
        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{ALLOWED_IMPORT_PATHS = \["/var/lib/pulp/sync_imports"\]})

        end
      end

      context 'with custom static dirs' do
        let :params do
          {
            apache_docroot: '/my/custom/directory',
            media_root: '/my/media/root',
            static_root: '/my/other/custom/directory',
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_file('/my/custom/directory')
          is_expected.to contain_file('/my/media/root')
          is_expected.to contain_file('/my/other/custom/directory')
          is_expected.to contain_apache__vhost('pulpcore')
            .with_docroot('/my/custom/directory')
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{MEDIA_ROOT = "/my/media/root"})
            .with_content(%r{STATIC_ROOT = "/my/other/custom/directory"})
        end
      end
    end
  end
end
