# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_distribution/cli'

describe Puppet::Type.type(:pulpcore_rpm_distribution).provider(:cli) do
  let(:resource_name) { 'test_distribution' }
  let(:base_path) { 'rpm/test' }
  let(:updated_base_path) { 'rpm/updated' }
  let(:repo_name) { 'test_repo' }

  def new_resource(attributes = {})
    Puppet::Type.type(:pulpcore_rpm_distribution).new(
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

  def stub_pulp(provider)
    allow(provider).to receive(:pulp)
  end

  describe '.resource_api_hashes' do
    it 'lists RPM distributions through the Pulp CLI and parses the JSON response' do
      api_hashes = [
        { 'name' => resource_name }
      ]

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hashes))

      expect(described_class.resource_api_hashes).to eq(api_hashes)
      expect(described_class).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'list',
        '--limit',
        1_000_000
      )
    end
  end

  describe '.resource_api_hash' do
    it 'shows an RPM distribution by name and parses the JSON response' do
      api_hash = { 'name' => resource_name }

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hash))

      expect(described_class.resource_api_hash(resource_name)).to eq(api_hash)
      expect(described_class).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'show',
        '--name',
        resource_name
      )
    end
  end

  describe '#create_resource' do
    it 'raises when base_path is missing during create' do
      provider = new_provider

      expect do
        provider.create_resource
      end.to raise_error(ArgumentError, %r{base_path.*required})
    end

    it 'creates a distribution with the required arguments' do
      provider = new_provider(base_path: base_path)

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'create',
        '--name',
        resource_name,
        '--base-path',
        base_path
      )
    end

    it 'includes repository when repo is set' do
      provider = new_provider(
        base_path: base_path,
        repo: repo_name
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'create',
        '--name',
        resource_name,
        '--base-path',
        base_path,
        '--repository',
        repo_name
      )
    end

    it 'does not include repository when repo is absent' do
      provider = new_provider(
        base_path: base_path,
        repo: :absent
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'create',
        '--name',
        resource_name,
        '--base-path',
        base_path
      )
    end

    it 'uses --checkpoint when checkpoint is true' do
      provider = new_provider(
        base_path: base_path,
        checkpoint: true
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'create',
        '--name',
        resource_name,
        '--base-path',
        base_path,
        '--checkpoint'
      )
    end

    it 'uses --not-checkpoint when checkpoint is false' do
      provider = new_provider(
        base_path: base_path,
        checkpoint: false
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'create',
        '--name',
        resource_name,
        '--base-path',
        base_path,
        '--not-checkpoint'
      )
    end
  end

  describe '#update_resource' do
    it 'updates only flushed scalar properties' do
      provider = new_provider

      provider.base_path = updated_base_path
      provider.repo = repo_name

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'update',
        '--name',
        resource_name,
        '--base-path',
        updated_base_path,
        '--repository',
        repo_name
      )
    end

    it 'clears repo using an empty string' do
      provider = new_provider

      provider.repo = :absent

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'update',
        '--name',
        resource_name,
        '--repository',
        ''
      )
    end

    it 'uses --checkpoint when checkpoint is true' do
      provider = new_provider

      provider.checkpoint = :true

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'update',
        '--name',
        resource_name,
        '--checkpoint'
      )
    end

    it 'uses --not-checkpoint when checkpoint is false' do
      provider = new_provider

      provider.checkpoint = :false

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'update',
        '--name',
        resource_name,
        '--not-checkpoint'
      )
    end
  end

  describe '#delete_resource' do
    it 'destroys the distribution by name' do
      provider = new_provider

      stub_pulp(provider)

      provider.delete_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'distribution',
        'destroy',
        '--name',
        resource_name
      )
    end
  end
end
