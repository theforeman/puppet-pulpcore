# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/pulpcore_rpm_repo/cli'

describe Puppet::Type.type(:pulpcore_rpm_repo).provider(:cli) do
  let(:resource_name) { 'test_repo' }
  let(:remote_name) { 'test_remote' }
  let(:description) { 'Test repository' }

  def new_resource(attributes = {})
    Puppet::Type.type(:pulpcore_rpm_repo).new(
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
    it 'lists RPM repositories through the Pulp CLI and parses the JSON response' do
      api_hashes = [
        { 'name' => resource_name }
      ]

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hashes))

      expect(described_class.resource_api_hashes).to eq(api_hashes)
      expect(described_class).to have_received(:pulp).with(
        'rpm',
        'repository',
        'list',
        '--limit',
        1_000_000
      )
    end
  end

  describe '.resource_api_hash' do
    it 'shows an RPM repository by name and parses the JSON response' do
      api_hash = { 'name' => resource_name }

      allow(described_class).to receive(:pulp).and_return(JSON.generate(api_hash))

      expect(described_class.resource_api_hash(resource_name)).to eq(api_hash)
      expect(described_class).to have_received(:pulp).with(
        'rpm',
        'repository',
        'show',
        '--name',
        resource_name
      )
    end
  end

  describe '#create_resource' do
    it 'creates a repository with the required arguments' do
      provider = new_provider

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'create',
        '--name',
        resource_name
      )
    end

    it 'includes optional properties when set' do
      provider = new_provider(
        description: description,
        remote: remote_name,
        retain_package_versions: '10',
        retain_repo_versions: '3'
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'create',
        '--name',
        resource_name,
        '--description',
        description,
        '--remote',
        remote_name,
        '--retain-package-versions',
        10,
        '--retain-repo-versions',
        3
      )
    end

    it 'does not include optional removable properties when they are absent' do
      provider = new_provider(
        description: :absent,
        remote: :absent,
        retain_repo_versions: :absent
      )

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'create',
        '--name',
        resource_name
      )
    end

    it 'uses --autopublish when autopublish is true' do
      provider = new_provider(autopublish: true)

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'create',
        '--name',
        resource_name,
        '--autopublish'
      )
    end

    it 'uses --no-autopublish when autopublish is false' do
      provider = new_provider(autopublish: false)

      stub_pulp(provider)

      provider.create_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'create',
        '--name',
        resource_name,
        '--no-autopublish'
      )
    end
  end

  describe '#update_resource' do
    it 'updates only flushed properties' do
      provider = new_provider

      provider.description = description
      provider.remote = remote_name
      provider.retain_package_versions = 10
      provider.retain_repo_versions = 3

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'update',
        '--name',
        resource_name,
        '--description',
        description,
        '--remote',
        remote_name,
        '--retain-package-versions',
        10,
        '--retain-repo-versions',
        3
      )
    end

    it 'clears removable properties using empty strings' do
      provider = new_provider

      provider.description = :absent
      provider.remote = :absent
      provider.retain_repo_versions = :absent

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'update',
        '--name',
        resource_name,
        '--description',
        '',
        '--remote',
        '',
        '--retain-repo-versions',
        ''
      )
    end

    it 'uses --autopublish when autopublish is true' do
      provider = new_provider

      provider.autopublish = :true

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'update',
        '--name',
        resource_name,
        '--autopublish'
      )
    end

    it 'uses --no-autopublish when autopublish is false' do
      provider = new_provider

      provider.autopublish = :false

      stub_pulp(provider)

      provider.update_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'update',
        '--name',
        resource_name,
        '--no-autopublish'
      )
    end
  end

  describe '#delete_resource' do
    it 'destroys the repository by name' do
      provider = new_provider

      stub_pulp(provider)

      provider.delete_resource

      expect(provider).to have_received(:pulp).with(
        'rpm',
        'repository',
        'destroy',
        '--name',
        resource_name
      )
    end
  end
end
