# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_remote/cli'

describe Puppet::Type.type(:pulpcore_rpm_remote).provider(:cli) do
  let(:resource_name) { 'test_remote' }
  let(:url) { 'https://example.com/pulp/content/test/' }
  let(:updated_url) { 'https://mirror.example.com/pulp/content/test/' }
  let(:policy) { 'on_demand' }
  let(:client_cert) { "-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----\n" }
  let(:client_key) { "-----BEGIN PRIVATE KEY-----\nMIIB\n-----END PRIVATE KEY-----\n" }
  let(:ca_cert) { "-----BEGIN CERTIFICATE-----\nMIIC\n-----END CERTIFICATE-----\n" }

  def new_resource(attributes = {})
    Puppet::Type.type(:pulpcore_rpm_remote).new(
      {
        name: resource_name,
        provider: :cli
      }.merge(attributes)
    )
  end

  def new_provider(attributes = {})
    described_class.new(name: resource_name).tap do |provider|
      provider.resource = new_resource(attributes)
    end
  end

  def stub_temp_file_arguments(provider, temporary_file_arguments = [])
    allow(provider).to receive(:with_temp_file_arguments) do |_file_arguments, &block|
      block.call(temporary_file_arguments)
    end
  end

  def stub_pulp(provider)
    allow(provider).to receive(:pulp)
  end

  describe '.resource_api_hashes' do
    it 'lists RPM remotes through the Pulp CLI and parses the JSON response' do
      api_hashes = [
        { 'name' => resource_name }
      ]

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hashes))

      expect(described_class.resource_api_hashes).to eq(api_hashes)
      expect(described_class).to have_received(:pulp).with('rpm', 'remote', 'list', '--limit', 1_000_000)
    end
  end

  describe '.resource_api_hash' do
    it 'shows an RPM remote by name and parses the JSON response' do
      api_hash = { 'name' => resource_name }

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hash))

      expect(described_class.resource_api_hash(resource_name)).to eq(api_hash)
      expect(described_class).to have_received(:pulp).with('rpm', 'remote', 'show', '--name', resource_name)
    end
  end

  describe '#create_resource' do
    it 'raises when url is missing during create' do
      provider = new_provider

      expect do
        provider.create_resource
      end.to raise_error(ArgumentError, %r{url.*required})
    end

    it 'creates a remote with the required arguments' do
      provider = new_provider(url: url)

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url
      )
    end

    it 'includes policy when set' do
      provider = new_provider(url: url, policy: policy)

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url,
        '--policy', policy
      )
    end

    it 'includes tls_validation when set' do
      provider = new_provider(url: url, tls_validation: false)

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url,
        '--tls-validation', 'false'
      )
    end

    it 'passes client certificate and key through temporary file arguments' do
      provider = new_provider(
        url: url,
        client_cert: client_cert,
        client_key: client_key
      )

      file_arguments = [
        ['--client-cert', client_cert],
        ['--client-key', client_key]
      ]

      stub_temp_file_arguments(
        provider,
        [
          '--client-cert', '@client-cert-file',
          '--client-key', '@client-key-file'
        ]
      )
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with(file_arguments)
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url,
        '--client-cert', '@client-cert-file',
        '--client-key', '@client-key-file'
      )
    end

    it 'passes ca_cert through temporary file arguments' do
      provider = new_provider(url: url, ca_cert: ca_cert)
      file_arguments = [
        ['--ca-cert', ca_cert]
      ]

      stub_temp_file_arguments(
        provider,
        [
          '--ca-cert', '@ca-cert-file'
        ]
      )
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with(file_arguments)
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url,
        '--ca-cert', '@ca-cert-file'
      )
    end

    it 'does not pass absent client_cert or absent ca_cert through temporary file arguments' do
      provider = new_provider(
        url: url,
        client_cert: :absent,
        ca_cert: :absent
      )

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'create',
        '--name', resource_name,
        '--url', url
      )
    end
  end

  describe '#update_resource' do
    it 'updates only flushed properties' do
      provider = new_provider

      provider.url = updated_url
      provider.policy = 'streamed'
      provider.tls_validation = :true

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'update',
        '--name', resource_name,
        '--url', updated_url,
        '--policy', 'streamed',
        '--tls-validation', 'true'
      )
    end

    it 'clears client certificate and key together when client_cert is absent' do
      provider = new_provider

      provider.client_cert = :absent

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'update',
        '--name', resource_name,
        '--client-cert', '',
        '--client-key', ''
      )
    end

    it 'clears ca_cert when ca_cert is absent' do
      provider = new_provider

      provider.ca_cert = :absent

      stub_temp_file_arguments(provider)
      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:with_temp_file_arguments).with([])
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'update',
        '--name', resource_name,
        '--ca-cert', ''
      )
    end

    it 'passes updated client certificate and key through temporary file arguments' do
      provider = new_provider(client_key: client_key)

      provider.client_cert = client_cert

      file_arguments = [
        ['--client-cert', client_cert],
        ['--client-key', client_key]
      ]

      stub_temp_file_arguments(
        provider,
        [
          '--client-cert', '@client-cert-file',
          '--client-key', '@client-key-file'
        ]
      )
      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:with_temp_file_arguments).with(file_arguments)
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'update',
        '--name', resource_name,
        '--client-cert', '@client-cert-file',
        '--client-key', '@client-key-file'
      )
    end

    it 'passes updated ca_cert through temporary file arguments' do
      provider = new_provider

      provider.ca_cert = ca_cert

      file_arguments = [
        ['--ca-cert', ca_cert]
      ]

      stub_temp_file_arguments(
        provider,
        [
          '--ca-cert', '@ca-cert-file'
        ]
      )
      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:with_temp_file_arguments).with(file_arguments)
      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'update',
        '--name', resource_name,
        '--ca-cert', '@ca-cert-file'
      )
    end
  end

  describe '#delete_resource' do
    it 'destroys the remote by name' do
      provider = new_provider

      stub_pulp(provider)

      provider.delete_resource

      expect(provider).to have_received(:pulp).with(
        'rpm', 'remote', 'destroy',
        '--name', resource_name
      )
    end
  end

  describe '#required_client_key' do
    it 'returns the configured client_key' do
      provider = new_provider(client_key: client_key)

      expect(provider.send(:required_client_key)).to eq(client_key)
    end

    it 'raises when client_key is missing' do
      provider = new_provider

      expect do
        provider.send(:required_client_key)
      end.to raise_error(Puppet::DevError, %r{client_key.*required})
    end

    it 'raises when client_key is absent' do
      provider = new_provider(client_key: :absent)

      expect do
        provider.send(:required_client_key)
      end.to raise_error(Puppet::DevError, %r{client_key.*required})
    end
  end
end
