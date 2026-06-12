# frozen_string_literal: true

require_relative '../pulpcore_cli'
require_relative '../pulpcore_rpm_remote'

Puppet::Type.type(:pulpcore_rpm_remote).provide(:cli, parent: Puppet::Provider::PulpcoreRpmRemote) do
  include Puppet::Provider::PulpcoreCli

  def self.resource_api_hashes
    parse_pulp_json(pulp('rpm', 'remote', 'list', '--limit', 1_000_000))
  end

  def self.resource_api_hash(remote_name)
    parse_pulp_json(pulp('rpm', 'remote', 'show', '--name', remote_name))
  end

  # url is mandatory to create a remote but optional once it exists (you may
  # manage only a subset of properties), so it can't be a required type-level
  # param. Enforce it here, at create time.
  def create_resource
    raise ArgumentError, '`url` is a required property when creating a `Pulpcore_rpm_remote` resource.' unless resource[:url]

    command_arguments = ['rpm', 'remote', 'create', '--name', resource[:name], '--url', resource[:url]]
    file_arguments = []

    command_arguments << '--policy' << resource[:policy] if resource[:policy]
    command_arguments << '--tls-validation' << resource[:tls_validation].to_s if resource[:tls_validation]

    if resource[:client_cert] && resource[:client_cert] != :absent
      file_arguments << ['--client-cert', resource[:client_cert]]
      file_arguments << ['--client-key', required_client_key]
    end

    file_arguments << ['--ca-cert', resource[:ca_cert]] if resource[:ca_cert] && resource[:ca_cert] != :absent

    with_temp_file_arguments(file_arguments) do |temporary_file_arguments|
      pulp(*(command_arguments + temporary_file_arguments))
    end
  end

  def update_resource
    command_arguments = ['rpm', 'remote', 'update', '--name', resource[:name]]
    file_arguments = []

    command_arguments << '--url'    << @property_flush[:url]    if @property_flush.key?(:url)
    command_arguments << '--policy' << @property_flush[:policy] if @property_flush.key?(:policy)

    command_arguments << '--tls-validation' << @property_flush[:tls_validation].to_s if @property_flush.key?(:tls_validation)

    if @property_flush.key?(:client_cert)
      if @property_flush[:client_cert] == ''
        command_arguments << '--client-cert' << ''
        command_arguments << '--client-key' << ''
      else
        file_arguments << ['--client-cert', @property_flush[:client_cert]]
        file_arguments << ['--client-key', required_client_key]
      end
    end

    if @property_flush.key?(:ca_cert)
      if @property_flush[:ca_cert] == ''
        command_arguments << '--ca-cert' << ''
      else
        file_arguments << ['--ca-cert', @property_flush[:ca_cert]]
      end
    end

    with_temp_file_arguments(file_arguments) do |temporary_file_arguments|
      pulp(*(command_arguments + temporary_file_arguments))
    end
  end

  def delete_resource
    pulp('rpm', 'remote', 'destroy', '--name', resource[:name])
  end

  private

  # The type's validate block already guarantees client_key is present whenever
  # client_cert is set, so a missing key here is an internal error rather than
  # bad user input, hence Puppet::DevError rather than ArgumentError.
  def required_client_key
    client_key = resource[:client_key]

    return client_key if client_key && client_key != :absent

    raise Puppet::DevError, '`client_key` was required while setting `client_cert`, but was not present.'
  end
end
