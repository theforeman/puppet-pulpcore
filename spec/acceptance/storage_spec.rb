require 'spec_helper_acceptance'

if fact('pulpcore_version') == 'nightly'
  describe 'with S3-compatible storage' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          class { 'pulpcore':
            storage_backend => 's3',
            storage_options => {
              'access_key'       => 'test',
              'secret_key'       => 'test',
              'bucket_name'      => 'pulp',
              'endpoint_url'     => 'https://object.example.test',
              'addressing_style' => 'path',
            },
          }
        PUPPET
      end
    end

    describe package('pulpcore-storage-s3') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/pulp/settings.py') do
      it { is_expected.to be_file }
      its(:content) { is_expected.not_to match(/^MEDIA_ROOT =/) }
      its(:content) { is_expected.to include('"BACKEND": "storages.backends.s3.S3Storage"') }
      its(:content) { is_expected.to include('"endpoint_url": "https://object.example.test"') }
      its(:content) { is_expected.to include('"BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"') }
    end

    describe command('PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager check') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
