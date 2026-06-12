# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_cli'

# Define a tiny test-only type/provider so the mixin is included into a real
# Puppet provider class.
Puppet::Type.newtype(:pulpcore_cli_test) do
  newparam(:name, namevar: true)
end

Puppet::Type.type(:pulpcore_cli_test).provide(:test) do
  include Puppet::Provider::PulpcoreCli
end

describe Puppet::Provider::PulpcoreCli do
  let(:provider_class) { Puppet::Type.type(:pulpcore_cli_test).provider(:test) }
  let(:provider) { provider_class.new(name: 'test') }
  let(:client_cert) { "-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----\n" }
  let(:client_key) { "-----BEGIN PRIVATE KEY-----\nMIIB\n-----END PRIVATE KEY-----\n" }

  describe '.pulp' do
    it 'adds JSON formatting before the supplied Pulp CLI arguments' do
      allow(provider_class).to receive(:pulp_binary).and_return('[]')

      expect(provider_class.pulp('rpm', 'remote', 'list')).to eq('[]')
      expect(provider_class).to have_received(:pulp_binary).with(
        '--format', 'json',
        'rpm', 'remote', 'list'
      )
    end
  end

  describe '.api_hash_by_href' do
    it 'shows an object by href and parses the JSON response' do
      api_hash = { 'name' => 'test_remote' }

      allow(provider_class).to receive(:pulp).and_return(JSON.generate(api_hash))

      expect(provider_class.api_hash_by_href('/pulp/api/v3/remotes/rpm/rpm/test/')).to eq(api_hash)
      expect(provider_class).to have_received(:pulp).with(
        'show',
        '--href',
        '/pulp/api/v3/remotes/rpm/rpm/test/'
      )
    end
  end

  describe '.parse_pulp_json' do
    it 'parses a valid JSON response' do
      expect(provider_class.parse_pulp_json('{"name":"test_remote"}')).to eq('name' => 'test_remote')
    end

    it 'raises a Puppet::Error when the response is not valid JSON' do
      expect do
        provider_class.parse_pulp_json("Warning: deprecated\n")
      end.to raise_error(Puppet::Error, %r{Unable to parse the Pulp CLI JSON response})
    end

    it 'includes the start of the offending response in the error' do
      expect do
        provider_class.parse_pulp_json("Warning: deprecated\n")
      end.to raise_error(Puppet::Error, %r{Warning: deprecated})
    end
  end

  describe '#pulp' do
    it 'delegates to the provider class pulp method' do
      allow(provider_class).to receive(:pulp).and_return('[]')

      expect(provider.pulp('rpm', 'remote', 'list')).to eq('[]')
      expect(provider_class).to have_received(:pulp).with('rpm', 'remote', 'list')
    end
  end

  describe '#with_temp_file_arguments' do
    def temporary_paths(arguments)
      arguments.each_slice(2).map do |_option, file_argument|
        file_argument.delete_prefix('@')
      end
    end

    def collect_temp_file_details(provider, file_arguments)
      details = {}

      provider.with_temp_file_arguments(file_arguments) do |arguments|
        paths = temporary_paths(arguments)

        details[:arguments] = arguments
        details[:paths] = paths
        details[:contents] = paths.map { |path| File.read(path) }
        details[:modes] = paths.map { |path| File.stat(path).mode & 0o777 }
        details[:exists_during_yield] = paths.map { |path| File.exist?(path) }
      end

      details
    end

    it 'yields command arguments using @file paths' do
      details = collect_temp_file_details(
        provider,
        [
          ['--client-cert', client_cert],
          ['--client-key', client_key]
        ]
      )

      expect(details[:arguments].values_at(0, 2)).to eq(['--client-cert', '--client-key'])
      expect(details[:arguments].values_at(1, 3)).to all(start_with('@'))
    end

    it 'writes supplied content to the temporary files' do
      details = collect_temp_file_details(
        provider,
        [
          ['--client-cert', client_cert],
          ['--client-key', client_key]
        ]
      )

      expect(details[:contents]).to eq([client_cert, client_key])
    end

    it 'uses owner-only file permissions' do
      details = collect_temp_file_details(
        provider,
        [
          ['--client-cert', client_cert],
          ['--client-key', client_key]
        ]
      )

      expect(details[:modes]).to eq([0o600, 0o600])
    end

    it 'keeps the temporary files available while the block is running' do
      details = collect_temp_file_details(
        provider,
        [
          ['--client-cert', client_cert],
          ['--client-key', client_key]
        ]
      )

      expect(details[:exists_during_yield]).to eq([true, true])
    end

    it 'removes the temporary files after the block exits' do
      details = collect_temp_file_details(
        provider,
        [
          ['--client-cert', client_cert],
          ['--client-key', client_key]
        ]
      )

      expect(details[:paths].map { |path| File.exist?(path) }).to eq([false, false])
    end

    it 'removes the temporary files when the block raises' do
      paths = []

      expect do
        provider.with_temp_file_arguments([['--client-cert', client_cert]]) do |arguments|
          paths = temporary_paths(arguments)

          raise 'test error'
        end
      end.to raise_error(RuntimeError, 'test error')

      expect(paths.map { |path| File.exist?(path) }).to eq([false])
    end

    it 'yields an empty argument list when there are no file arguments' do
      yielded_arguments = nil

      provider.with_temp_file_arguments([]) do |arguments|
        yielded_arguments = arguments
      end

      expect(yielded_arguments).to eq([])
    end
  end
end
