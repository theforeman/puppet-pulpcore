# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_distribution'

describe Puppet::Provider::PulpcoreRpmDistribution do
  let(:resource_name) { 'test_distribution' }
  let(:base_path) { 'rpm/test' }
  let(:repo_name) { 'test_repo' }
  let(:repo_href) { '/pulp/api/v3/repositories/rpm/rpm/test_repo/' }
  let(:provider) { described_class.new(name: resource_name, ensure: :present) }

  def property_flush(provider)
    provider.instance_variable_get(:@property_flush)
  end

  before do
    described_class.instance_variable_set(:@name_by_href, {})
  end

  describe '.resource_properties_from_api_hash' do
    def distribution_api_hash
      {
        'name' => resource_name,
        'base_path' => base_path,
        'repository' => repo_href,
        'checkpoint' => true
      }
    end

    it 'maps Pulp API fields to Puppet provider properties' do
      allow(described_class).to receive(:api_hash_by_href).and_return('name' => repo_name)

      expect(described_class.resource_properties_from_api_hash(distribution_api_hash)).to eq(
        name: resource_name,
        ensure: :present,
        provider: described_class.name,
        base_path: base_path,
        repo: repo_name,
        checkpoint: :true
      )

      expect(described_class).to have_received(:api_hash_by_href).with(repo_href)
    end

    it 'maps nil repository to :absent' do
      api_hash = distribution_api_hash
      api_hash['repository'] = nil

      expect(described_class.resource_properties_from_api_hash(api_hash)[:repo]).to eq(:absent)
    end

    it 'maps false checkpoint to :false' do
      api_hash = distribution_api_hash
      api_hash['repository'] = nil
      api_hash['checkpoint'] = false

      expect(described_class.resource_properties_from_api_hash(api_hash)[:checkpoint]).to eq(:false)
    end
  end

  describe 'property setters' do
    it 'stores base_path changes in property_flush' do
      provider.base_path = base_path

      expect(property_flush(provider)).to eq(base_path: base_path)
    end

    it 'stores repo changes in property_flush' do
      provider.repo = repo_name

      expect(property_flush(provider)).to eq(repo: repo_name)
    end

    it 'stores an empty string when repo is set to absent' do
      provider.repo = :absent

      expect(property_flush(provider)).to eq(repo: '')
    end

    it 'stores checkpoint changes in property_flush' do
      provider.checkpoint = :true

      expect(property_flush(provider)).to eq(checkpoint: :true)
    end
  end
end
