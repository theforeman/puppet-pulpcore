# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:pulpcore_rpm_remote) do
  let(:valid_cert) do
    <<~CERT
      -----BEGIN CERTIFICATE-----
      MIIB
      -----END CERTIFICATE-----
    CERT
  end

  let(:valid_key) do
    <<~KEY
      -----BEGIN PRIVATE KEY-----
      MIIB
      -----END PRIVATE KEY-----
    KEY
  end

  let(:resource_name) { 'test_remote' }

  def new_resource(attributes = {})
    described_class.new({ name: resource_name }.merge(attributes))
  end

  def resource_with_provider(attributes = {}, client_key_set:)
    resource = new_resource(attributes)

    provider = Object.new
    provider.define_singleton_method(:client_key_set?) { client_key_set }

    allow(resource).to receive(:provider).and_return(provider)

    resource
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

  describe 'url' do
    ['http://example.com/repo', 'https://example.com/repo', 'uln://ol8_x86_64_baseos_latest'].each do |url|
      it "accepts #{url}" do
        expect(new_resource(url: url)[:url]).to eq(url)
      end
    end

    ['ftp://example.com/repo', 'example.com/repo', 'https://'].each do |url|
      it "rejects #{url}" do
        expect do
          new_resource(url: url)
        end.to raise_error(Puppet::Error)
      end
    end
  end

  describe 'policy' do
    %w[immediate on_demand streamed].each do |policy|
      it "accepts #{policy}" do
        expect(new_resource(policy: policy)[:policy]).to eq(policy)
      end
    end

    it 'rejects invalid policies' do
      expect do
        new_resource(policy: 'lazy')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'tls_validation' do
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
        expect(new_resource(tls_validation: input)[:tls_validation]).to eq(expected)
      end
    end

    it 'rejects invalid boolean values' do
      expect do
        new_resource(tls_validation: 'maybe')
      end.to raise_error(%r{expected a boolean value})
    end
  end

  describe 'client_cert' do
    it 'accepts a PEM certificate when client_key is provided' do
      resource = new_resource(client_cert: valid_cert, client_key: valid_key)

      expect(resource[:client_cert]).to eq(valid_cert)
    end

    it 'accepts absent' do
      expect(new_resource(client_cert: 'absent')[:client_cert]).to eq(:absent)
    end

    it 'rejects invalid certificate content' do
      expect do
        new_resource(client_cert: 'not a certificate', client_key: valid_key)
      end.to raise_error(Puppet::Error)
    end

    it 'is in sync when the certificate matches and the hidden client key is set' do
      resource = resource_with_provider(
        { client_cert: valid_cert, client_key: valid_key },
        client_key_set: true
      )

      expect(resource.property(:client_cert).insync?(valid_cert)).to be(true)
    end

    it 'is out of sync when the certificate matches but the hidden client key is not set' do
      resource = resource_with_provider(
        { client_cert: valid_cert, client_key: valid_key },
        client_key_set: false
      )

      expect(resource.property(:client_cert).insync?(valid_cert)).to be(false)
    end

    it 'is in sync when absent and the hidden client key is not set' do
      resource = resource_with_provider(
        { client_cert: :absent },
        client_key_set: false
      )

      expect(resource.property(:client_cert).insync?(:absent)).to be(true)
    end

    it 'is out of sync when absent but the hidden client key is still set' do
      resource = resource_with_provider(
        { client_cert: :absent },
        client_key_set: true
      )

      expect(resource.property(:client_cert).insync?(:absent)).to be(false)
    end
  end

  describe 'client_key' do
    it 'accepts a PEM private key' do
      expect(new_resource(client_key: valid_key)[:client_key]).to eq(valid_key)
    end

    it 'accepts absent' do
      expect(new_resource(client_key: 'absent')[:client_key]).to eq(:absent)
    end

    it 'rejects invalid private key content' do
      expect do
        new_resource(client_key: 'not a private key')
      end.to raise_error(Puppet::Error)
    end

    it 'is required when client_cert is set' do
      expect do
        new_resource(client_cert: valid_cert)
      end.to raise_error(Puppet::Error, %r{client_key.*required})
    end

    it 'treats client_key => absent as missing when client_cert is set' do
      expect do
        new_resource(client_cert: valid_cert, client_key: :absent)
      end.to raise_error(Puppet::Error, %r{client_key.*required})
    end

    it 'is not required when client_cert is absent' do
      expect(new_resource(client_cert: :absent)[:client_cert]).to eq(:absent)
    end

    it 'marks client_key as sensitive when present' do
      resource = new_resource(client_key: valid_key)

      resource.send(:set_sensitive_parameters, [])

      expect(resource.parameter(:client_key).sensitive).to be(true)
    end
  end

  describe 'ca_cert' do
    it 'accepts a PEM certificate' do
      expect(new_resource(ca_cert: valid_cert)[:ca_cert]).to eq(valid_cert)
    end

    it 'accepts absent' do
      expect(new_resource(ca_cert: 'absent')[:ca_cert]).to eq(:absent)
    end

    it 'rejects invalid certificate content' do
      expect do
        new_resource(ca_cert: 'not a certificate')
      end.to raise_error(Puppet::Error)
    end
  end
end
