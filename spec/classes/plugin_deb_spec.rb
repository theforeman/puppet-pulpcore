require 'spec_helper'

describe 'pulpcore::plugin::deb' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pulpcore__plugin('deb') }
      it { is_expected.to contain_package('python3-pulp-deb') }
      it { is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-plugin-deb') }
      it { is_expected.not_to contain_apache__vhost__fragment('pulpcore-https-plugin-deb') }

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('deb')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end

        context 'with pulp2 content route' do
          let(:params) { { use_pulp2_content_route: true } }

          it 'contains the Apache fragment' do
            is_expected.to compile.with_all_deps
            is_expected.to contain_pulpcore__apache__fragment('plugin-deb')
            is_expected.to contain_apache__vhost__fragment('pulpcore-http-plugin-deb')
              .with_content(
<<CONTENT

  <Location "/pulp/deb">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content timeout=600
    ProxyPassReverse unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content
  </Location>
CONTENT
              )
            is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-deb')
              .with_content(
<<CONTENT

  <Location "/pulp/deb">
    RequestHeader unset X-CLIENT-CERT
    RequestHeader set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT
    ProxyPass unix:///run/pulpcore-content.sock|http://pulpcore-content/pulp/content timeout=600
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
