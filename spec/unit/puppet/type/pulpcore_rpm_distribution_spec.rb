# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:pulpcore_rpm_distribution) do
  let(:resource_name) { 'test_distribution' }
  let(:repo_name) { 'test_repo' }

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

  describe 'base_path' do
    it 'accepts a non-empty base path' do
      expect(new_resource(base_path: 'rpm/test')[:base_path]).to eq('rpm/test')
    end

    it 'rejects an empty base path' do
      expect do
        new_resource(base_path: '')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'repo' do
    it 'accepts a repository name' do
      expect(new_resource(repo: repo_name)[:repo]).to eq(repo_name)
    end

    it 'accepts absent' do
      expect(new_resource(repo: 'absent')[:repo]).to eq(:absent)
    end

    it 'rejects an empty string' do
      expect do
        new_resource(repo: '')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'checkpoint' do
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
        expect(new_resource(checkpoint: input)[:checkpoint]).to eq(expected)
      end
    end

    it 'rejects invalid boolean values' do
      expect do
        new_resource(checkpoint: 'maybe')
      end.to raise_error(%r{expected a boolean value})
    end
  end

  describe 'autorequire' do
    it 'autorequires the configured repository' do
      catalog = Puppet::Resource::Catalog.new
      repo = Puppet::Type.type(:pulpcore_rpm_repo).new(name: repo_name)
      distribution = new_resource(repo: repo_name)

      catalog.add_resource(repo)
      catalog.add_resource(distribution)

      relationships = distribution.autorequire

      expect(relationships.map(&:source)).to include(repo)
      expect(relationships.map(&:target)).to include(distribution)
    end

    it 'does not autorequire a repository when repo is absent' do
      catalog = Puppet::Resource::Catalog.new
      distribution = new_resource(repo: :absent)

      catalog.add_resource(distribution)

      expect(distribution.autorequire).to be_empty
    end

    it 'does not autorequire a repository when repo is unset' do
      catalog = Puppet::Resource::Catalog.new
      distribution = new_resource

      catalog.add_resource(distribution)

      expect(distribution.autorequire).to be_empty
    end
  end
end
