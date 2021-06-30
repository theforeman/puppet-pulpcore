require 'spec_helper'

describe 'pulpcore' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { override_facts(os_facts, os: {selinux: {enabled: true}}) }

      context 'manage_redis false' do
        let(:params) do
          { manage_redis: false }
        end

        context 'use_rq_tasking_system false' do
          let(:params) do
            super().merge({ use_rq_tasking_system: false })
          end

          context 'pulp_cache_enable false' do
            let(:params) do
              super().merge({ pulp_cache_enable: false })
            end

            it { is_expected.to compile.with_all_deps }

            it 'does not configure redis' do
              is_expected.not_to contain_class('redis')
            end

            it 'does not configure pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .without_content(/REDIS_HOST/)
                .without_content(/REDIS_PORT/)
                .without_content(/REDIS_DB/)
            end
          end

          context 'pulp_cache_enable true' do
            let(:params) do
              super().merge({ pulp_cache_enable: true })
            end

            it { is_expected.to compile.with_all_deps }

            it 'does not configure redis' do
              is_expected.not_to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end
        end

        context 'use_rq_tasking_system true' do
          let(:params) do
            super().merge({ use_rq_tasking_system: true })
          end

          context 'pulp_cache_enable false' do
            let(:params) do
              super().merge({ pulp_cache_enable: false })
            end

            it { is_expected.to compile.with_all_deps }

            it 'does not configure redis' do
              is_expected.not_to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end

          context 'pulp_cache_enable true' do
            let(:params) do
              super().merge({ pulp_cache_enable: true })
            end

            it { is_expected.to compile.with_all_deps }

            it 'does not configure redis' do
              is_expected.not_to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end
        end
      end

      context 'manage_redis true' do
        let(:params) do
          { manage_redis: true }
        end

        context 'use_rq_tasking_system false' do
          let(:params) do
            super().merge({ use_rq_tasking_system: false })
          end

          context 'pulp_cache_enable false' do
            let(:params) do
              super().merge({ pulp_cache_enable: false })
            end

            it { is_expected.to compile.with_all_deps }

            it 'does not configure redis' do
              is_expected.not_to contain_class('redis')
            end

            it 'does not configure pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .without_content(/REDIS_HOST/)
                .without_content(/REDIS_PORT/)
                .without_content(/REDIS_DB/)
            end
          end

          context 'pulp_cache_enable true' do
            let(:params) do
              super().merge({ pulp_cache_enable: true })
            end

            it { is_expected.to compile.with_all_deps }

            it 'configures redis' do
              is_expected.to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end
        end

        context 'use_rq_tasking_system true' do
          let(:params) do
            super().merge({ use_rq_tasking_system: true })
          end

          context 'pulp_cache_enable false' do
            let(:params) do
              super().merge({ pulp_cache_enable: false })
            end

            it { is_expected.to compile.with_all_deps }

            it 'configures redis' do
              is_expected.to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end

          context 'pulp_cache_enable true' do
            let(:params) do
              super().merge({ pulp_cache_enable: true })
            end

            it { is_expected.to compile.with_all_deps }

            it 'configures redis' do
              is_expected.to contain_class('redis')
            end

            it 'configures pulpcore connection to redis' do
              is_expected.to contain_concat__fragment('base')
                .with_content(/REDIS_HOST/)
                .with_content(/REDIS_PORT/)
                .with_content(/REDIS_DB/)
            end
          end
        end
      end
    end
  end
end
