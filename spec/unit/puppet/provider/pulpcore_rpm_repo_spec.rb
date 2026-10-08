# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_repo'

describe Puppet::Provider::PulpcoreRpmRepo do
  let(:resource_name) { 'test_repo' }
  let(:remote_name) { 'test_remote' }
  let(:remote_href) { '/pulp/api/v3/remotes/rpm/rpm/test_remote/' }
  let(:provider) { described_class.new(name: resource_name, ensure: :present) }
  let(:description) { 'Test repository' }
  let(:signing_service_name) { 'test_signing_service' }
  let(:signing_service_href) { '/pulp/api/v3/signing-services/test_signing_service/' }

  def property_flush(provider)
    provider.instance_variable_get(:@property_flush)
  end

  before do
    # Reset the cache
    described_class.instance_variable_set(:@name_by_href, {})
  end

  describe '.resource_properties_from_api_hash' do
    let(:repo_api_hash) do
      {
        'name' => resource_name,
        'description' => description,
        'remote' => remote_href,
        'retain_package_versions' => 10,
        'retain_repo_versions' => 3,
        'autopublish' => true,
        'metadata_signing_service' => signing_service_href
      }
    end

    before do
      allow(described_class).to receive(:api_hash_by_href).with(remote_href).and_return('name' => remote_name)
      allow(described_class).to receive(:api_hash_by_href).with(signing_service_href).and_return('name' => signing_service_name)
    end

    it 'maps Pulp API fields to Puppet provider properties' do

      expect(described_class.resource_properties_from_api_hash(repo_api_hash)).to eq(
        name: resource_name,
        ensure: :present,
        provider: described_class.name,
        description: description,
        remote: remote_name,
        retain_package_versions: 10,
        retain_repo_versions: 3,
        autopublish: :true,
        metadata_signing_service: signing_service_name
      )

      expect(described_class).to have_received(:api_hash_by_href).with(remote_href)
      expect(described_class).to have_received(:api_hash_by_href).with(signing_service_href)
    end

    it 'maps nil removable fields to :absent' do
      api_hash = repo_api_hash
      api_hash['description'] = nil
      api_hash['remote'] = nil
      api_hash['retain_repo_versions'] = nil
      api_hash['metadata_signing_service'] = nil

      expect(described_class.resource_properties_from_api_hash(api_hash)).to include(
        description: :absent,
        remote: :absent,
        retain_repo_versions: :absent,
        metadata_signing_service: :absent
      )
    end

    it 'maps false autopublish to :false' do
      api_hash = repo_api_hash
      api_hash['remote'] = nil
      api_hash['autopublish'] = false

      expect(described_class.resource_properties_from_api_hash(api_hash)[:autopublish]).to eq(:false)
    end
  end

  describe 'property setters' do
    it 'stores description changes in property_flush' do
      provider.description = description

      expect(property_flush(provider)).to eq(description: description)
    end

    it 'stores an empty string when description is set to absent' do
      provider.description = :absent

      expect(property_flush(provider)).to eq(description: '')
    end

    it 'stores remote changes in property_flush' do
      provider.remote = remote_name

      expect(property_flush(provider)).to eq(remote: remote_name)
    end

    it 'stores an empty string when remote is set to absent' do
      provider.remote = :absent

      expect(property_flush(provider)).to eq(remote: '')
    end

    it 'stores retain_repo_versions changes in property_flush' do
      provider.retain_repo_versions = 3

      expect(property_flush(provider)).to eq(retain_repo_versions: 3)
    end

    it 'stores an empty string when retain_repo_versions is set to absent' do
      provider.retain_repo_versions = :absent

      expect(property_flush(provider)).to eq(retain_repo_versions: '')
    end

    it 'stores retain_package_versions changes in property_flush' do
      provider.retain_package_versions = 10

      expect(property_flush(provider)).to eq(retain_package_versions: 10)
    end

    it 'stores autopublish changes in property_flush' do
      provider.autopublish = :true

      expect(property_flush(provider)).to eq(autopublish: :true)
    end

    it 'stores metadata_signing_service changes in property_flush' do
      provider.metadata_signing_service = signing_service_name

      expect(property_flush(provider)).to eq(metadata_signing_service: signing_service_name)
    end

    it 'stores an empty string when metadata_signing_service is set to absent' do
      provider.metadata_signing_service = :absent

      expect(property_flush(provider)).to eq(metadata_signing_service: '')
    end
  end
end
