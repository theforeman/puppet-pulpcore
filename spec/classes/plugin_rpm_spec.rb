require 'spec_helper'

describe 'pulpcore::plugin::rpm' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('pulpcore-plugin(rpm)') }
      it { is_expected.to contain_pulpcore__plugin('rpm') }
      it { is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-plugin-rpm') }
      it { is_expected.not_to contain_apache__vhost__fragment('pulpcore-https-plugin-rpm') }

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('rpm')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
          is_expected.not_to contain_concat__fragment('plugin-rpm')
        end

        context 'with allow_unsafe_advisory_conflict_resolution' do
          let(:params) { { allow_automatic_unsafe_advisory_conflict_resolution: true } }

          it 'configures pulpcore with ALLOW_AUTOMATIC_UNSAFE_ADVISORY_CONFLICT_RESOLUTION' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat__fragment('plugin-rpm')
              .with_content("\n# rpm plugin settings\nALLOW_AUTOMATIC_UNSAFE_ADVISORY_CONFLICT_RESOLUTION = True\n")
          end
        end

        context 'with keep_changelog_limit' do
          let(:params) { { keep_changelog_limit: 20 } }

          it 'configures pulpcore with KEEP_CHANGELOG_LIMIT' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_concat__fragment('plugin-rpm')
              .with_content("\n# rpm plugin settings\nKEEP_CHANGELOG_LIMIT = 20\n")
          end
        end

        context 'with pulp2 content route' do
          let(:params) { { use_pulp2_content_route: true } }

          it 'contains the Apache fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_pulpcore__apache__fragment('plugin-rpm')
            is_expected.to contain_apache__vhost__fragment('pulpcore-http-plugin-rpm')
              .with_content(
<<CONTENT

  <Location "/pulp/repos">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content disablereuse=on timeout=600
    ProxyPassReverse unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content
  </Location>
CONTENT
              )
            is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-rpm')
              .with_content(
<<CONTENT

  <Location "/pulp/repos">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content disablereuse=on timeout=600
    ProxyPassReverse unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content
  </Location>
CONTENT
              )
          end
        end
      end
    end
  end
end
