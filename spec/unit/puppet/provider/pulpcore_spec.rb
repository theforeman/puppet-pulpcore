# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore'

# Define a tiny test-only type so Pulpcore#update_property_hash can read
# resource[:name] from a real Puppet resource.
Puppet::Type.newtype(:pulpcore_provider_test) do
  newparam(:name, namevar: true)
end

describe Puppet::Provider::Pulpcore do
  let(:resource_name) { 'test_resource' }
  let(:provider) { described_class.new(name: resource_name) }

  def test_resource(resource_name)
    Puppet::Type.type(:pulpcore_provider_test).new(name: resource_name)
  end

  def property_flush(provider)
    provider.instance_variable_get(:@property_flush)
  end

  def property_hash(provider)
    provider.instance_variable_get(:@property_hash)
  end

  describe '.resource_api_hashes' do
    it 'raises Puppet::DevError' do
      expect do
        described_class.resource_api_hashes
      end.to raise_error(Puppet::DevError, %r{must implement \.resource_api_hashes})
    end
  end

  describe '.resource_api_hash' do
    it 'raises Puppet::DevError' do
      expect do
        described_class.resource_api_hash(resource_name)
      end.to raise_error(Puppet::DevError, %r{must implement \.resource_api_hash})
    end
  end

  describe '.resource_properties_from_api_hash' do
    it 'raises Puppet::DevError' do
      expect do
        described_class.resource_properties_from_api_hash({})
      end.to raise_error(Puppet::DevError, %r{must implement \.resource_properties_from_api_hash})
    end
  end

  describe '.api_hash_by_href' do
    it 'raises Puppet::DevError' do
      expect do
        described_class.api_hash_by_href('/pulp/api/v3/repositories/rpm/rpm/test/')
      end.to raise_error(Puppet::DevError, %r{must implement \.api_hash_by_href})
    end
  end

  describe '.name_by_href' do
    let(:href) { '/pulp/api/v3/repositories/rpm/rpm/test/' }
    let(:provider_class) do
      Class.new(described_class) do
        def self.api_hash_by_href(_href)
          { 'name' => 'resolved_name' }
        end
      end
    end

    it 'returns :absent when the href is nil' do
      expect(provider_class.name_by_href(nil)).to eq(:absent)
    end

    it 'resolves an href to the referenced resource name' do
      expect(provider_class.name_by_href(href)).to eq('resolved_name')
    end

    it 'memoises lookups by href' do
      allow(provider_class).to receive(:api_hash_by_href).and_return('name' => 'resolved_name')

      expect(provider_class.name_by_href(href)).to eq('resolved_name')
      expect(provider_class.name_by_href(href)).to eq('resolved_name')

      expect(provider_class).to have_received(:api_hash_by_href).once
    end
  end

  describe '#create_resource' do
    it 'raises Puppet::DevError' do
      expect do
        provider.create_resource
      end.to raise_error(Puppet::DevError, %r{must implement #create_resource})
    end
  end

  describe '#update_resource' do
    it 'raises Puppet::DevError' do
      expect do
        provider.update_resource
      end.to raise_error(Puppet::DevError, %r{must implement #update_resource})
    end
  end

  describe '#delete_resource' do
    it 'raises Puppet::DevError' do
      expect do
        provider.delete_resource
      end.to raise_error(Puppet::DevError, %r{must implement #delete_resource})
    end
  end

  describe '.mk_property_hash_getters' do
    let(:provider_class) do
      Class.new(described_class) do
        mk_property_hash_getters(:description)
      end
    end

    it 'returns :absent when the stored value is nil' do
      provider = provider_class.new(description: nil)

      expect(provider.description).to eq(:absent)
    end

    it 'returns the stored value when the current value is present' do
      provider = provider_class.new(description: 'test description')

      expect(provider.description).to eq('test description')
    end
  end

  describe '.instances' do
    let(:provider_class) do
      Class.new(described_class) do
        mk_property_hash_getters(:name)

        def self.resource_api_hashes
          [
            { 'name' => 'one' },
            { 'name' => 'two' }
          ]
        end

        def self.resource_properties_from_api_hash(api_hash)
          {
            name: api_hash['name'],
            ensure: :present
          }
        end
      end
    end

    it 'builds provider instances from API hashes' do
      instances = provider_class.instances

      expect(instances.map(&:class)).to eq([provider_class, provider_class])
      expect(instances.map(&:name)).to eq(%w[one two])
    end
  end

  describe '.resource_properties' do
    context 'when the API hash is found' do
      let(:provider_class) do
        Class.new(described_class) do
          def self.resource_api_hash(resource_name)
            {
              'name' => resource_name,
              'description' => 'from api'
            }
          end

          def self.resource_properties_from_api_hash(api_hash)
            {
              name: api_hash['name'],
              ensure: :present,
              description: api_hash['description']
            }
          end
        end
      end

      it 'maps one API hash' do
        expect(provider_class.resource_properties(resource_name)).to eq(
          name: resource_name,
          ensure: :present,
          description: 'from api'
        )
      end
    end

    context 'when resource_api_hash raises Puppet::ExecutionFailure' do
      let(:provider_class) do
        Class.new(described_class) do
          def self.resource_api_hash(_resource_name)
            raise Puppet::ExecutionFailure, 'not found'
          end
        end
      end

      it 'returns an empty hash' do
        allow(provider_class).to receive(:warning)

        expect(provider_class.resource_properties(resource_name)).to eq({})
        expect(provider_class).to have_received(:warning).with(%r{#resource_properties had an error})
      end
    end
  end

  describe '#flush' do
    let(:provider_class) do
      Class.new(described_class) do
        mk_property_hash_getters(:description)

        def self.resource_properties(resource_name)
          {
            name: resource_name,
            ensure: :present,
            description: "refetched #{resource_name}"
          }
        end

        def description=(value)
          @property_flush[:description] = value
        end

        def create_resource; end

        def update_resource; end

        def delete_resource; end
      end
    end

    let(:provider) do
      provider_class.new(name: resource_name, ensure: :present).tap do |provider|
        provider.resource = test_resource(resource_name)
      end
    end

    it 'calls create_resource when ensure was set to present' do
      allow(provider).to receive(:create_resource)

      provider.create
      provider.flush

      expect(provider).to have_received(:create_resource)
      expect(provider.description).to eq("refetched #{resource_name}")
    end

    it 'calls update_resource for property-only changes' do
      allow(provider).to receive(:update_resource)

      provider.description = 'changed'
      provider.flush

      expect(provider).to have_received(:update_resource)
      expect(provider.description).to eq("refetched #{resource_name}")
    end

    it 'calls delete_resource when ensure was set to absent' do
      allow(provider).to receive(:delete_resource)

      provider.destroy
      provider.flush

      expect(provider).to have_received(:delete_resource)
      expect(provider.exists?).to be(false)
    end

    it 'clears property_flush after creating' do
      allow(provider).to receive(:create_resource)

      provider.create
      provider.flush

      expect(property_flush(provider)).to eq({})
    end

    it 'clears property_flush after updating' do
      allow(provider).to receive(:update_resource)

      provider.description = 'changed'
      provider.flush

      expect(property_flush(provider)).to eq({})
    end

    it 'clears property_flush after deleting' do
      allow(provider).to receive(:delete_resource)

      provider.destroy
      provider.flush

      expect(property_flush(provider)).to eq({})
      expect(property_hash(provider)).to eq({})
    end
  end
end
