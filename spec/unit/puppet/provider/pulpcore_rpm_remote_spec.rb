# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_remote'

describe Puppet::Provider::PulpcoreRpmRemote do
  let(:resource_name) { 'test_remote' }
  let(:url) { 'https://example.com/pulp/content/test/' }
  let(:policy) { 'on_demand' }
  let(:client_cert) { "-----BEGIN CERTIFICATE-----\nMIIB\n-----END CERTIFICATE-----\n" }
  let(:ca_cert) { "-----BEGIN CERTIFICATE-----\nMIIC\n-----END CERTIFICATE-----\n" }

  let(:remote_api_hash) do
    {
      'name' => resource_name,
      'url' => url,
      'policy' => policy,
      'tls_validation' => true,
      'client_cert' => client_cert,
      'ca_cert' => ca_cert,
      'hidden_fields' => [
        { 'name' => 'client_key', 'is_set' => true }
      ]
    }
  end

  def new_provider(attributes = {})
    described_class.new({ name: resource_name, ensure: :present }.merge(attributes))
  end

  def property_flush(provider)
    provider.instance_variable_get(:@property_flush)
  end

  describe '.resource_properties_from_api_hash' do
    it 'maps Pulp API fields to Puppet provider properties' do
      expect(described_class.resource_properties_from_api_hash(remote_api_hash)).to eq(
        name: resource_name,
        ensure: :present,
        provider: described_class.name,
        url: url,
        policy: policy,
        tls_validation: :true,
        client_cert: client_cert,
        ca_cert: ca_cert,
        client_key_set: true
      )
    end

    it 'maps false tls_validation to :false' do
      api_hash = remote_api_hash
      api_hash['tls_validation'] = false

      expect(described_class.resource_properties_from_api_hash(api_hash)[:tls_validation]).to eq(:false)
    end

    it 'maps nil client_cert to :absent' do
      api_hash = remote_api_hash
      api_hash['client_cert'] = nil

      expect(described_class.resource_properties_from_api_hash(api_hash)[:client_cert]).to eq(:absent)
    end

    it 'maps nil ca_cert to :absent' do
      api_hash = remote_api_hash
      api_hash['ca_cert'] = nil

      expect(described_class.resource_properties_from_api_hash(api_hash)[:ca_cert]).to eq(:absent)
    end

    it 'raises when hidden_fields is missing' do
      api_hash = remote_api_hash
      api_hash.delete('hidden_fields')

      expect do
        described_class.resource_properties_from_api_hash(api_hash)
      end.to raise_error(Puppet::Error, %r{did not include hidden_fields})
    end

    it 'raises when hidden_fields is nil' do
      api_hash = remote_api_hash
      api_hash['hidden_fields'] = nil

      expect do
        described_class.resource_properties_from_api_hash(api_hash)
      end.to raise_error(Puppet::Error, %r{hidden_fields was nil})
    end

    it 'raises when hidden_fields does not include client_key' do
      api_hash = remote_api_hash
      api_hash['hidden_fields'] = [
        { 'name' => 'proxy_password', 'is_set' => true }
      ]

      expect do
        described_class.resource_properties_from_api_hash(api_hash)
      end.to raise_error(Puppet::Error, %r{did not include client_key in hidden_fields})
    end
  end

  describe '.hidden_field_set?' do
    it 'returns true when the named hidden field is set' do
      api_hash = {
        'hidden_fields' => [
          { 'name' => 'client_key', 'is_set' => true }
        ]
      }

      expect(described_class.hidden_field_set?(api_hash, 'client_key')).to be(true)
    end

    it 'returns false when the named hidden field is not set' do
      api_hash = {
        'hidden_fields' => [
          { 'name' => 'client_key', 'is_set' => false }
        ]
      }

      expect(described_class.hidden_field_set?(api_hash, 'client_key')).to be(false)
    end

    it 'raises when the named hidden field is absent' do
      api_hash = {
        'hidden_fields' => [
          { 'name' => 'proxy_username', 'is_set' => true }
        ]
      }

      expect do
        described_class.hidden_field_set?(api_hash, 'client_key')
      end.to raise_error(Puppet::Error, %r{did not include client_key in hidden_fields})
    end

    it 'raises when hidden_fields is nil' do
      expect do
        described_class.hidden_field_set?({ 'hidden_fields' => nil }, 'client_key')
      end.to raise_error(Puppet::Error, %r{hidden_fields was nil})
    end

    it 'raises when hidden_fields is missing' do
      expect do
        described_class.hidden_field_set?({}, 'client_key')
      end.to raise_error(Puppet::Error, %r{did not include hidden_fields})
    end
  end

  describe '#client_key_set?' do
    it 'returns true when client_key_set is true' do
      expect(new_provider(client_key_set: true).client_key_set?).to be(true)
    end

    it 'returns false when client_key_set is false' do
      expect(new_provider(client_key_set: false).client_key_set?).to be(false)
    end
  end

  describe 'property setters' do
    it 'stores url changes in property_flush' do
      provider = new_provider

      provider.url = url

      expect(property_flush(provider)).to eq(url: url)
    end

    it 'stores policy changes in property_flush' do
      provider = new_provider

      provider.policy = policy

      expect(property_flush(provider)).to eq(policy: policy)
    end

    it 'stores tls_validation changes in property_flush' do
      provider = new_provider

      provider.tls_validation = :false

      expect(property_flush(provider)).to eq(tls_validation: :false)
    end

    it 'stores client_cert changes in property_flush' do
      provider = new_provider

      provider.client_cert = client_cert

      expect(property_flush(provider)).to eq(client_cert: client_cert)
    end

    it 'stores an empty string when client_cert is set to absent' do
      provider = new_provider

      provider.client_cert = :absent

      expect(property_flush(provider)).to eq(client_cert: '')
    end

    it 'stores ca_cert changes in property_flush' do
      provider = new_provider

      provider.ca_cert = ca_cert

      expect(property_flush(provider)).to eq(ca_cert: ca_cert)
    end

    it 'stores an empty string when ca_cert is set to absent' do
      provider = new_provider

      provider.ca_cert = :absent

      expect(property_flush(provider)).to eq(ca_cert: '')
    end
  end
end
