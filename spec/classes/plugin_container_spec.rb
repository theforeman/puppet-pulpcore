require 'spec_helper'

describe 'pulpcore::plugin::container' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      describe 'default params' do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include pulpcore' }

        it 'configures the plugin' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('container')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
          is_expected.to contain_package('python3-pulp-container')
          is_expected.to contain_concat__fragment('plugin-container').with_content("\n# container plugin settings\nTOKEN_AUTH_DISABLED=True")
          is_expected.to contain_pulpcore__apache__fragment('plugin-container')
          is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-plugin-container')
          is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-container')
            .with_content(
<<CONTENT

  <Location "/pulpcore_registry/v2/">
    RequestHeader unset REMOTE_USER
    RequestHeader set REMOTE_USER "%{SSL_CLIENT_S_DN_CN}s" env=SSL_CLIENT_S_DN_CN
    ProxyPass unix:///run/pulpcore-api.sock|http://foo.example.com/v2/
    ProxyPassReverse unix:///run/pulpcore-api.sock|http://foo.example.com/v2/
  </Location>

  ProxyPass /pulp/container/ unix:///run/pulpcore-content.sock|http://foo.example.com/pulp/container/
  ProxyPassReverse /pulp/container/ unix:///run/pulpcore-content.sock|http://foo.example.com/pulp/container/
CONTENT
            )
        end
      end

      describe 'set registry base url' do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include pulpcore' }

        let(:params) do
          {
            registry_base_url: 'unix:///run/test.sock|http://example.com'
          }
        end

        it 'configures the plugin' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('container')
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
          is_expected.to contain_package('python3-pulp-container')
          is_expected.to contain_concat__fragment('plugin-container').with_content("\n# container plugin settings\nTOKEN_AUTH_DISABLED=True")
          is_expected.to contain_pulpcore__apache__fragment('plugin-container')
          is_expected.not_to contain_apache__vhost__fragment('pulpcore-http-plugin-container')
          is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-container')
            .with_content(
<<CONTENT

  <Location "/pulpcore_registry/v2/">
    RequestHeader unset REMOTE_USER
    RequestHeader set REMOTE_USER "%{SSL_CLIENT_S_DN_CN}s" env=SSL_CLIENT_S_DN_CN
    ProxyPass unix:///run/test.sock|http://example.com/v2/
    ProxyPassReverse unix:///run/test.sock|http://example.com/v2/
  </Location>

  ProxyPass /pulp/container/ unix:///run/pulpcore-content.sock|http://foo.example.com/pulp/container/
  ProxyPassReverse /pulp/container/ unix:///run/pulpcore-content.sock|http://foo.example.com/pulp/container/
CONTENT
            )
        end
      end
    end
  end
end
