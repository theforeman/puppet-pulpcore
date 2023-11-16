require 'spec_helper'

describe 'pulpcore::repo' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe "with default values" do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_anchor('pulpcore::repo') }
        it { is_expected.to contain_yumrepo('pulpcore')
          .with_baseurl(%r{https://yum.theforeman.org/pulpcore/\d+\.\d+/el\d+/\$basearch$})
          .with_gpgcheck(1)
          .with_gpgkey(%r{https://yum.theforeman.org/pulpcore/\d+\.\d+/GPG-RPM-KEY-pulpcore})
          .that_notifies('Anchor[pulpcore::repo]')
        }

        if os_facts[:os]['release']['major'] == '8'
          it 'configures the pulpcore module' do
            is_expected.to contain_package('pulpcore-dnf-module')
              .with_name('pulpcore')
              .with_ensure(/^el\d+/)
              .with_enable_only(true)
              .with_provider('dnfmodule')
              .that_requires('Yumrepo[pulpcore]')
              .that_notifies('Anchor[pulpcore::repo]')
          end
        else
          it { is_expected.not_to contain_package('pulpcore-dnf-module') }
        end
      end

      describe "with nightly version" do
        let :params do
          {
            version: 'nightly',
            gpgkey: '',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_yumrepo('pulpcore')
          .with_baseurl(%r{https://yum.theforeman.org/pulpcore/nightly/el\d+/\$basearch$})
          .with_gpgcheck(0)
          .that_notifies('Anchor[pulpcore::repo]')
        }
      end
    end
  end
end
