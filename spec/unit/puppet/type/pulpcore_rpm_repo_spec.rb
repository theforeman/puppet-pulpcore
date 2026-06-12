# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:pulpcore_rpm_repo) do
  let(:resource_name) { 'test_repo' }
  let(:remote_name) { 'test_remote' }

  def new_resource(attributes = {})
    described_class.new({ name: resource_name }.merge(attributes))
  end

  describe 'namevar' do
    it 'uses name as the namevar' do
      expect(described_class.key_attributes).to eq([:name])
    end
  end

  describe 'ensure' do
    it 'is ensurable' do
      expect(described_class.attrtype(:ensure)).to eq(:property)
    end

    it 'accepts absent' do
      expect(new_resource(ensure: :absent)[:ensure]).to eq(:absent)
    end
  end

  describe 'description' do
    it 'accepts a description' do
      expect(new_resource(description: 'Test repository')[:description]).to eq('Test repository')
    end

    it 'accepts absent' do
      expect(new_resource(description: 'absent')[:description]).to eq(:absent)
    end

    it 'rejects an empty string' do
      expect do
        new_resource(description: '')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'remote' do
    it 'accepts a remote name' do
      expect(new_resource(remote: remote_name)[:remote]).to eq(remote_name)
    end

    it 'accepts absent' do
      expect(new_resource(remote: 'absent')[:remote]).to eq(:absent)
    end

    it 'rejects an empty string' do
      expect do
        new_resource(remote: '')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'retain_package_versions' do
    it 'munges numeric strings to integers' do
      expect(new_resource(retain_package_versions: '10')[:retain_package_versions]).to eq(10)
    end

    it 'accepts zero' do
      expect(new_resource(retain_package_versions: '0')[:retain_package_versions]).to eq(0)
    end

    it 'rejects non-numeric values' do
      expect do
        new_resource(retain_package_versions: 'many')
      end.to raise_error(Puppet::Error)
    end

    it 'rejects negative values' do
      expect do
        new_resource(retain_package_versions: '-1')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'retain_repo_versions' do
    it 'munges numeric strings to integers' do
      expect(new_resource(retain_repo_versions: '3')[:retain_repo_versions]).to eq(3)
    end

    it 'accepts zero' do
      expect(new_resource(retain_repo_versions: '0')[:retain_repo_versions]).to eq(0)
    end

    it 'accepts absent' do
      expect(new_resource(retain_repo_versions: 'absent')[:retain_repo_versions]).to eq(:absent)
    end

    it 'rejects non-numeric values' do
      expect do
        new_resource(retain_repo_versions: 'many')
      end.to raise_error(Puppet::Error)
    end

    it 'rejects negative values' do
      expect do
        new_resource(retain_repo_versions: '-1')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'autopublish' do
    {
      true => :true,
      :true => :true,
      'true' => :true,
      'yes' => :true,
      false => :false,
      :false => :false,
      'false' => :false,
      'no' => :false
    }.each do |input, expected|
      it "munges #{input.inspect} to #{expected.inspect}" do
        expect(new_resource(autopublish: input)[:autopublish]).to eq(expected)
      end
    end

    it 'rejects invalid boolean values' do
      expect do
        new_resource(autopublish: 'maybe')
      end.to raise_error(%r{expected a boolean value})
    end
  end

  describe 'autorequire' do
    it 'autorequires the configured remote' do
      catalog = Puppet::Resource::Catalog.new
      remote = Puppet::Type.type(:pulpcore_rpm_remote).new(name: remote_name)
      repo = new_resource(remote: remote_name)

      catalog.add_resource(remote)
      catalog.add_resource(repo)

      relationships = repo.autorequire

      expect(relationships.map(&:source)).to include(remote)
      expect(relationships.map(&:target)).to include(repo)
    end

    it 'does not autorequire a remote when remote is absent' do
      catalog = Puppet::Resource::Catalog.new
      repo = new_resource(remote: :absent)

      catalog.add_resource(repo)

      expect(repo.autorequire).to be_empty
    end

    it 'does not autorequire a remote when remote is unset' do
      catalog = Puppet::Resource::Catalog.new
      repo = new_resource

      catalog.add_resource(repo)

      expect(repo.autorequire).to be_empty
    end
  end
end
