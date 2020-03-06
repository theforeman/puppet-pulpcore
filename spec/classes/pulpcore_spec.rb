require 'spec_helper'

describe 'pulpcore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default params' do
        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_package('python3-pulpcore')
          is_expected.to contain_concat__fragment('base')
            .without_content(/REMOTE_USER_ENVIRON_NAME/)
            .without_content(/sslmode/)
          is_expected.to contain_class('postgresql::server')
          is_expected.to contain_postgresql__server__db('pulpcore')
          is_expected.to contain_apache__vhost('pulp')
          is_expected.to contain_selinux__boolean('httpd_can_network_connect')
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
          is_expected.not_to contain_apache__vhost('pulp')
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
          is_expected.to contain_apache__vhost('pulp')
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
      end

      context 'external postgresql with SSL' do
        let :params do
          {
            postgresql_db_host: '192.0.2.222',
            postgresql_manage_db: false,
            postgresql_db_ssl: true,
            postgresql_db_ssl_require: true,
            postgresql_db_ssl_cert: '/etc/pki/katello/certs/pulpcore-database.crt',
            postgresql_db_ssl_key: '/etc/pki/katello/private/pulpcore-database.key',
            postgresql_db_ssl_root_ca: '/etc/pki/tls/certs/ca-bundle.crt',
          }
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

      context 'with custom static dirs' do
        let :params do
          {
            webserver_static_dir: '/my/custom/directory',
            pulp_static_root: '/my/other/custom/directory',
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_file('/my/custom/directory')
          is_expected.to contain_exec('python3-django-admin collectstatic --noinput')
            .with_environment([
              "DJANGO_SETTINGS_MODULE=pulpcore.app.settings",
              "PULP_SETTINGS=/etc/pulp/settings.py",
              "PULP_STATIC_ROOT=/my/other/custom/directory"
            ])
          is_expected.to contain_systemd__unit_file('pulpcore-api.service')
            .with_content(%r{Environment="PULP_STATIC_ROOT=/my/other/custom/directory"})
          is_expected.to contain_apache__vhost('pulp')
            .with_docroot('/my/custom/directory')
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{MEDIA_ROOT = "/my/custom/directory"})
        end
      end
    end
  end
end
