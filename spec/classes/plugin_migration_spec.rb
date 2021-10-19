require 'spec_helper'

migration_config = <<-EOL
PULP2_MONGODB = {
    "name": "pulp_database",
    "seeds": "localhost:27017",
    "ssl": False,
    "verify_ssl": True,
    "ca_path": "/etc/pki/tls/certs/ca-bundle.crt",
}
EOL

describe 'pulpcore::plugin::migration' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_pulpcore__plugin('migration') }
      it { is_expected.to contain_package('pulpcore-plugin(2to3-migration)') }
      it { is_expected.to contain_concat__fragment('plugin-migration').with_content("\n# migration plugin settings\n#{migration_config}") }

      context 'with pulpcore' do
        let(:pre_condition) { 'include pulpcore' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_pulpcore__plugin('migration')
            .with_package_name('pulpcore-plugin(2to3-migration)')
            .with_config(migration_config)
            .that_subscribes_to('Class[Pulpcore::Install]')
            .that_notifies(['Class[Pulpcore::Database]', 'Class[Pulpcore::Service]'])
        end
      end
    end
  end
end
