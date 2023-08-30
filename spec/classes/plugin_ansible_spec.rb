require 'spec_helper'

describe 'pulpcore::plugin::ansible' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include pulpcore' }
      let(:expected_vhost_content) do
<<CONTENT

  ProxyPass /pulp_ansible/galaxy/ unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp_ansible/galaxy/
  ProxyPassReverse /pulp_ansible/galaxy/ unix:///run/pulpcore-api.sock|http://pulpcore-api/pulp_ansible/galaxy/
CONTENT
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('pulpcore-plugin(ansible)') }
      it { is_expected.to contain_pulpcore__plugin('ansible') }
      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_pulpcore__plugin('ansible')
          .that_subscribes_to('Class[Pulpcore::Install]')
          .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        is_expected.to contain_apache__vhost__fragment('pulpcore-https-plugin-ansible')
                           .with_content(expected_vhost_content)
        is_expected.to contain_concat__fragment('plugin-ansible')
          .with_content(%r{^ANSIBLE_API_HOSTNAME = "https://foo.example.com"})
          .with_content(%r{^ANSIBLE_CONTENT_HOSTNAME = "https://foo.example.com/pulp/content"})
          .without_content(/ANSIBLE_PERMISSION_CLASSES/)
      end

      context 'with permission classes' do
        context 'set to an empty array' do
          let(:params) { { permission_classes: [] } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_concat__fragment('plugin-ansible').with_content(/^ANSIBLE_PERMISSION_CLASSES = \[\]$/) }
        end

        context 'set to a value' do
          let(:params) { { permission_classes: ['foo', 'bar'] } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_concat__fragment('plugin-ansible').with_content(/^ANSIBLE_PERMISSION_CLASSES = \["foo", "bar"\]$/) }
        end
      end
    end
  end
end
