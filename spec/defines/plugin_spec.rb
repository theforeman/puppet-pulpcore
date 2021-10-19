require 'spec_helper'

describe 'pulpcore::plugin' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'myplugin' }

      context 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_package('pulpcore-plugin(myplugin)').with_ensure('present') }
      end

      context 'with package name' do
        let(:params) { { package_name: 'breaking-conventions' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_package('pulpcore-plugin(myplugin)') }
        it { is_expected.to create_package('breaking-conventions').with_ensure('present') }
      end
    end
  end
end
