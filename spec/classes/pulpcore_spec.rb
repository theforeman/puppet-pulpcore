require 'spec_helper'

describe 'pulpcore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { override_facts(os_facts, processors: {count: 1}, os: {selinux: {enabled: true}}) }

      context 'default params' do
        it { is_expected.to compile.with_all_deps }

        it 'installs' do
          is_expected.to contain_class('pulpcore::install')
          is_expected.to contain_package('pulpcore')
          is_expected.to contain_package('pulpcore-selinux')
          is_expected.to contain_user('pulp').with_gid('pulp').with_home('/var/lib/pulp')
          is_expected.to contain_group('pulp')
        end

        it 'configures pulpcore' do
          is_expected.to contain_class('pulpcore::config')
          is_expected.to contain_concat('pulpcore settings').with_path('/etc/pulp/settings.py')
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{ALLOWED_EXPORT_PATHS = \[\]})
            .with_content(%r{ALLOWED_IMPORT_PATHS = \["/var/lib/pulp/sync_imports"\]})
            .with_content(%r{ALLOWED_CONTENT_CHECKSUMS = \["sha224", "sha256", "sha384", "sha512"\]})
            .with_content(%r{REDIS_URL = "redis\+unix:///var/run/redis/redis\.sock\?db=8"})
            .with_content(%r{CACHE_ENABLED = False})
            .with_content(%r{# ANALYTICS = False})
            .without_content(%r{sslmode})
            .without_content(%r{WORKER_TTL})
          is_expected.to contain_concat__fragment('logging').with_content(<<~LOGGING)
            LOGGING = {
                "dynaconf_merge": True,
                "loggers": {
                    '': {
                        'handlers': ['console'],
                        'level': 'INFO',
                    },
                    'pulpcore.deprecation': {
                        'handlers': ['console'],
                        'level': 'ERROR',
                        'propagate': False,
                    },
                    'django_guid': {
                        'handlers': ['console'],
                        'level': 'WARNING',
                        'propagate': False,
                    },
                },
            }
          LOGGING
          is_expected.to contain_file('/etc/pulp')
          is_expected.to contain_file('/etc/pulp/certs/database_fields.symmetric.key')
          is_expected.to contain_file('/var/lib/pulp')
          is_expected.to contain_file('/var/lib/pulp/sync_imports')
          is_expected.to contain_file('/var/lib/pulp/assets')
          is_expected.to contain_file('/var/lib/pulp/media')
          is_expected.to contain_file('/var/lib/pulp/pulpcore_static')
          is_expected.to contain_file('/var/lib/pulp/tmp')
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
          is_expected.to contain_class('redis').that_comes_before('Class[pulpcore::service]')
        end

        it 'configures apache' do
          is_expected.to contain_class('pulpcore::apache')
          is_expected.to contain_apache__vhost('pulpcore')
            .with_serveraliases([])
            .with_directories([
              {
                'provider'       => 'Directory',
                'path'           => '/var/lib/pulp/pulpcore_static',
                'options'        => ['-Indexes', '-FollowSymLinks'],
                'allow_override' => ['None'],
              },
              {
                'path'            => '/pulp/content',
                'provider'        => 'location',
                'proxy_pass'      => [{
                  'url'    => 'unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content',
                  'params' => {'timeout' => '600', 'disablereuse' => 'on'},
                }],
                'request_headers' => [
                  'unset X-CLIENT-CERT',
                  'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
                  'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
                ],
              },
            ])
          is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-pulpcore')
          is_expected.to contain_apache__vhost('pulpcore-https')
            .with_serveraliases([])
            .with_directories([
              {
                'path'           => '/var/lib/pulp/pulpcore_static',
                'provider'       => 'Directory',
                'options'        => ['-Indexes', '-FollowSymLinks'],
                'allow_override' => ['None'],
              },
              {
                'path'            => '/pulp/content',
                'provider'        => 'location',
                'proxy_pass'      => [{
                  'url'    => 'unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content',
                  'params' => {'timeout' => '600', 'disablereuse' => 'on'},
                }],
                'request_headers' => [
                  'unset X-CLIENT-CERT',
                  'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
                  'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
                ],
              },
              {
                'path'            => '/pulp/api/v3',
                'provider'        => 'location',
                'proxy_pass'      => [{
                  'url'    => 'unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp/api/v3',
                  'params' => {'timeout' => '600'},
                }],
                'request_headers' => [
                  'unset REMOTE-USER',
                  'unset REMOTE_USER',
                  'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
                ],
              }
            ])
            .with_proxy_pass([
              {
                'path' => '/assets/',
                'url'  => 'unix:///run/pulpcore-api.sock|http://pulpcore-api/assets/',
              },
            ])
          is_expected.not_to contain_apache__vhost__fragment('pulpcore-https-pulpcore')
          is_expected.to contain_selboolean('httpd_can_network_connect')
        end

        it 'configures services' do
          is_expected.to contain_class('pulpcore::service')
          is_expected.to contain_pulpcore__socket_service('pulpcore-api')
          is_expected.to contain_systemd__unit_file('pulpcore-api.socket')
          is_expected.to contain_systemd__unit_file('pulpcore-api.service').with_content(%r{--workers 2})
            .with_content(%r{--max-requests 800})
            .with_content(%r{--max-requests-jitter 100})
          is_expected.to contain_file('/etc/systemd/system/pulpcore-api.socket').that_comes_before('Service[pulpcore-api.service]')
          is_expected.to contain_pulpcore__socket_service('pulpcore-content')
          is_expected.to contain_systemd__unit_file('pulpcore-content.socket')
          is_expected.to contain_systemd__unit_file('pulpcore-content.service')
          is_expected.to contain_file('/etc/systemd/system/pulpcore-content.socket').that_comes_before('Service[pulpcore-content.service]')
          is_expected.to contain_systemd__unit_file('pulpcore-resource-manager.service').with_ensure('absent')
          is_expected.to contain_systemd__unit_file('pulpcore-worker@.service')
          is_expected.to contain_service("pulpcore-worker@1.service").with_ensure(true)
          is_expected.not_to contain_service("pulpcore-worker@2.service")
        end
      end

      context 'with changed max-requests' do
        let :params do
          {
            api_service_worker_max_requests: 100,
            api_service_worker_max_requests_jitter: 10
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_systemd__unit_file('pulpcore-api.service')
            .with_content(%r{--max-requests 100})
            .with_content(%r{--max-requests-jitter 10})
        end
      end

      context 'with allowed import paths' do
        let :params do
          {
            allowed_import_path: ['/tmp/imports', '/tmp/imports1'],
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{ALLOWED_IMPORT_PATHS = \["/tmp/imports", "/tmp/imports1"\]})
          is_expected.to contain_file('/tmp/imports1')
          is_expected.to contain_file('/tmp/imports').with(
            :mode => '0770',
            :owner => 'pulp',
            :group => 'pulp'
          )
        end

        context 'with overlapping allowed export paths' do
          let(:params) { super().merge(allowed_export_path: ['/tmp/imports', '/tmp/exports']) }

          it do
            is_expected.to compile.with_all_deps
            is_expected.to contain_file('/tmp/imports')
            is_expected.to contain_file('/tmp/imports1')
            is_expected.to contain_file('/tmp/exports')
          end
        end
      end

      context 'with allowed export paths' do
        let :params do
          {
            allowed_export_path: ['/tmp/exports', '/tmp/exports1'],
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{ALLOWED_EXPORT_PATHS = \["/tmp/exports", "/tmp/exports1"\]})
          is_expected.to contain_file('/tmp/exports1')
          is_expected.to contain_file('/tmp/exports').with(
            :mode => '0770',
            :owner => 'pulp',
            :group => 'pulp'
          )
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
                .with_ensure(true)
                .with_enable(true)
            end
            is_expected.to contain_service('pulpcore-worker@6.service')
              .with_ensure(false)
              .with_enable(false)
          end
        end

        context 'with 4 workers from fact' do
          let(:facts) { super().merge(pulpcore_workers: (1..4).map { |n| "pulpcore-worker@#{n}.service" } ) }

          it 'is expected to increase the workers to 5' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure(true)
                .with_enable(true)
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
                .with_ensure(true)
                .with_enable(true)
            end
            is_expected.not_to contain_service('pulpcore-worker@6.service')
          end
        end

        context 'fact absent' do
          it 'is expected to enable 5 workers' do
            is_expected.to compile.with_all_deps
            (1..5).each do |n|
              is_expected.to contain_service("pulpcore-worker@#{n}.service")
                .with_ensure(true)
                .with_enable(true)
            end
            is_expected.not_to contain_service('pulpcore-worker@6.service')
          end
        end
      end

      context 'without apache httpd' do
        let :params do
          {
            apache_http_vhost: false,
            apache_https_vhost: false,
          }
        end

        it do
          is_expected.to compile.with_all_deps
          is_expected.not_to contain_file('/var/lib/pulp/pulpcore_static')
          is_expected.not_to contain_apache__vhost('pulpcore')
          is_expected.not_to contain_apache__vhost('pulpcore-https')
          is_expected.not_to contain_selboolean('httpd_can_network_connect')
        end
      end

      context 'with external vhosts' do
        let :params do
          {
            apache_http_vhost: 'foreman',
            apache_https_vhost: 'foreman-ssl',
          }
        end

        let :pre_condition do
          <<~PUPPET
          include apache
          apache::vhost { 'foreman':
            docroot => '/usr/share/foreman/public',
            port    => 80,
          }

          apache::vhost { 'foreman-ssl':
            docroot => '/usr/share/foreman/public',
            port    => 443,
            ssl     => true,
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_pulpcore__apache__fragment('pulpcore')
          is_expected.to contain_apache__vhost__fragment('pulpcore-http-pulpcore')
            .with_vhost('foreman')
            .with_priority('10')
            .with_content(
<<CONTENT

  <Location "/pulp/content">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    RequestHeader set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content disablereuse=on timeout=600
    ProxyPassReverse unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content
  </Location>
CONTENT
            )
        end
        it do
          is_expected.to contain_pulpcore__apache__fragment('pulpcore')
          is_expected.to contain_apache__vhost__fragment('pulpcore-https-pulpcore')
            .with_vhost('foreman-ssl')
            .with_priority('10')
            .with_content(
<<CONTENT

  <Location "/pulp/content">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    RequestHeader set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content disablereuse=on timeout=600
    ProxyPassReverse unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content
  </Location>

  <Location "/pulp/api/v3">
    RequestHeader unset REMOTE-USER
    RequestHeader unset REMOTE_USER
    RequestHeader set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}
    ProxyPass unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp/api/v3 timeout=600
    ProxyPassReverse unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp/api/v3
  </Location>

  ProxyPass /assets/ unix:///run/pulpcore-api.sock|http://pulpcore-api/assets/
  ProxyPassReverse /assets/ unix:///run/pulpcore-api.sock|http://pulpcore-api/assets/
CONTENT
            )
        end
      end

      context 'with a plugin' do
        let(:pre_condition) { "pulpcore::plugin { 'myplugin': }" }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('myplugin')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
          is_expected.to contain_package('pulpcore-plugin(myplugin)')
        end
      end

      context 'with the repo' do
        let(:pre_condition) { 'include pulpcore::repo' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('pulpcore::repo')
          is_expected.to contain_yumrepo('pulpcore').that_notifies('Class[pulpcore::install]')
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

      context 'can disable services' do
        let :params do
          {
            service_enable: false
          }
        end

        it do
          is_expected.to contain_systemd__unit_file("pulpcore-api.socket").with_enable(false)
          is_expected.to contain_systemd__unit_file("pulpcore-api.service").with_enable(false)
          is_expected.to contain_systemd__unit_file("pulpcore-content.service").with_enable(false)
          is_expected.to contain_systemd__unit_file("pulpcore-content.socket").with_enable(false)
          is_expected.to contain_service("pulpcore-worker@1.service").with_enable(false)
        end
      end

      context 'can ensure services are stopped' do
        let :params do
          {
            service_ensure: false
          }
        end

        it do
          is_expected.to contain_systemd__unit_file("pulpcore-api.socket").with_active(false)
          is_expected.to contain_systemd__unit_file("pulpcore-api.service").with_active(false)
          is_expected.to contain_systemd__unit_file("pulpcore-content.service").with_active(false)
          is_expected.to contain_systemd__unit_file("pulpcore-content.socket").with_active(false)
          is_expected.to contain_service("pulpcore-worker@1.service").with_ensure(false)
        end
      end

      context 'with API client auth common names' do
        let :params do
          {
            'api_client_auth_cn_map': {'foreman.example.com' => 'admin'}
          }
        end

        it do
          is_expected.to contain_apache__vhost('pulpcore-https')
            .with_directories([
              {
                'provider'       => 'Directory',
                'path'           => '/var/lib/pulp/pulpcore_static',
                'options'        => ['-Indexes', '-FollowSymLinks'],
                'allow_override' => ['None'],
              },
              {
                'path'            => '/pulp/content',
                'provider'        => 'location',
                'proxy_pass'      => [{
                  'url'    => 'unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content',
                  'params' => {'timeout' => '600', 'disablereuse' => 'on'},
                }],
                'request_headers' => [
                  'unset X-CLIENT-CERT',
                  'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
                  'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
                ],
              },
              {
                'path'            => '/pulp/api/v3',
                'provider'        => 'location',
                'proxy_pass'      => [{
                  'url'    => 'unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp/api/v3',
                  'params' => {'timeout' => '600'},
                }],
                'request_headers' => [
                  'unset REMOTE-USER',
                  'unset REMOTE_USER',
                  'set REMOTE-USER "admin" "expr=%{tolower:%{SSL_CLIENT_S_DN_CN}} == \'foreman.example.com\'"',
                  'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
                ],
              }
            ])
        end
      end

      context 'can enable content caching and set an expires' do
        let :params do
          {
            cache_enabled: true,
            cache_expires_ttl: 60,
          }
        end

        it do
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{CACHE_ENABLED = True})
            .with_content(%r{CACHE_SETTINGS = \{\n    'EXPIRES_TTL': 60,\n\}})
        end
      end

      context 'with log level and loggers set' do
        let(:params) do
          {
            log_level: 'DEBUG',
            loggers: {
              'pulpcore.deprecation' => {
                'level' => 'INFO',
              },
              'pulpcore.something' => {
                'level' => 'CRITICAL',
              }
            },
          }
        end

        it do
          is_expected.to contain_concat__fragment('logging').with_content(<<~LOGGING)
            LOGGING = {
                "dynaconf_merge": True,
                "loggers": {
                    '': {
                        'handlers': ['console'],
                        'level': 'DEBUG',
                    },
                    'pulpcore.deprecation': {
                        'handlers': ['console'],
                        'level': 'INFO',
                        'propagate': False,
                    },
                    'django_guid': {
                        'handlers': ['console'],
                        'level': 'WARNING',
                        'propagate': False,
                    },
                    'pulpcore.something': {
                        'handlers': ['console'],
                        'level': 'CRITICAL',
                        'propagate': False,
                    },
                },
            }
          LOGGING
        end
      end

      context 'with parameter worker_ttl = 60' do
        let :params do
          { worker_ttl: 60 }
        end

        it 'configures pulpcore with setting WORKER_TTL = 60' do
          is_expected.to contain_concat__fragment('base')
            .with_content(%r{^WORKER_TTL = 60$})
        end
      end

      context 'with 24 processors from facts and default worker_count' do
        let(:facts) { override_facts(os_facts, processors: {count: 24}) }

        it 'enables only 8 pulpcore workers' do
          (1..8).each do |i|
            is_expected.to contain_service("pulpcore-worker@#{i}.service")
              .with_ensure(true)
              .with_enable(true)
          end

          (9..24).each do |i|
            is_expected.not_to contain_service("pulpcore-worker@#{i}.service")
          end
        end
      end

      context 'with 24 workers previously enabled and reset to default worker_count' do
        let(:facts) {
          override_facts(
            os_facts,
            processors: {count: 24},
            pulpcore_workers: (1..24).map { |i| "pulpcore-worker@#{i}.service" }
          )
        }

        it 'enables 8 pulpcore workers' do
          (1..8).each do |i|
            is_expected.to contain_service("pulpcore-worker@#{i}.service")
              .with_ensure(true)
              .with_enable(true)
          end
        end

        it 'disables existing workers from previous configuration' do
          (9..24).each do |i|
            is_expected.to contain_service("pulpcore-worker@#{i}.service")
              .with_ensure(false)
              .with_enable(false)
          end
        end
      end

      context 'configured for 12 workers and only 8 processors' do
        let(:facts) { override_facts(os_facts, processors: { count: 8 }) }

        let(:params) do
          {
            worker_count: 12
          }
        end

        it 'allows configuring more workers than processors' do
          (1..12).each do |i|
            is_expected.to contain_service("pulpcore-worker@#{i}.service")
              .with_ensure(true)
              .with_enable(true)
          end
        end
      end

      context 'with external redis' do
        let(:params) do
          {
            redis_url: 'redis://redis.example.com:12345/7',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment('base').with_content(include('REDIS_URL = "redis://redis.example.com:12345/7"')) }
        it { is_expected.not_to contain_class('redis') }
      end
    end
  end
end
