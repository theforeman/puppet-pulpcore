require 'spec_helper'

describe 'pulpcore::plugin::python' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include pulpcore' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('pulpcore-plugin(python)') }
      it { is_expected.to contain_pulpcore__plugin('python') }

      it do
        is_expected.to contain_pulpcore__plugin('python')
          .that_subscribes_to('Class[Pulpcore::Install]')
          .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
      end

      it do
        is_expected.to contain_pulpcore__plugin('python')
          .with_http_content(%r{<Location "/pypi">})
          .with_http_content(%r{RequestHeader unset X-CLIENT-CERT})
          .with_http_content(%r{RequestHeader set X-CLIENT-CERT})
          .with_http_content(%r{RequestHeader set X-FORWARDED-PROTO})
          .with_http_content(%r{ProxyPass})
          .with_https_content(%r{<Location "/pypi">})
          .with_https_content(%r{RequestHeader unset X-CLIENT-CERT})
          .with_https_content(%r{RequestHeader set X-CLIENT-CERT})
          .with_https_content(%r{RequestHeader set X-FORWARDED-PROTO})
          .with_https_content(%r{ProxyPass})
      end
    end
  end
end
