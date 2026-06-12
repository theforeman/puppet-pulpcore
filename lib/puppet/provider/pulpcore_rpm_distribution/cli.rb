# frozen_string_literal: true

require_relative '../pulpcore_cli'
require_relative '../pulpcore_rpm_distribution'

Puppet::Type.type(:pulpcore_rpm_distribution).provide(:cli, parent: Puppet::Provider::PulpcoreRpmDistribution) do
  include Puppet::Provider::PulpcoreCli

  def self.resource_api_hashes
    parse_pulp_json(pulp('rpm', 'distribution', 'list', '--limit', 1_000_000))
  end

  def self.resource_api_hash(distribution_name)
    parse_pulp_json(pulp('rpm', 'distribution', 'show', '--name', distribution_name))
  end

  # base_path is mandatory to create a distribution but optional once it exists
  # (you may manage only a subset of properties), so it can't be a required
  # type-level param. Enforce it here, at create time.
  def create_resource
    raise ArgumentError, '`base_path` is a required property when creating a `Pulpcore_rpm_distribution` resource.' unless resource[:base_path]

    command_arguments = [
      'rpm', 'distribution', 'create',
      '--name', resource[:name],
      '--base-path', resource[:base_path]
    ]

    command_arguments << '--repository' << resource[:repo] if resource[:repo] && resource[:repo] != :absent

    case resource[:checkpoint]
    when :true
      command_arguments << '--checkpoint'
    when :false
      command_arguments << '--not-checkpoint'
    end

    pulp(*command_arguments)
  end

  def update_resource
    command_arguments = ['rpm', 'distribution', 'update', '--name', resource[:name]]

    command_arguments << '--base-path'  << @property_flush[:base_path] if @property_flush.key?(:base_path)
    command_arguments << '--repository' << @property_flush[:repo]      if @property_flush.key?(:repo)

    case @property_flush[:checkpoint]
    when :true
      command_arguments << '--checkpoint'
    when :false
      command_arguments << '--not-checkpoint'
    end

    pulp(*command_arguments)
  end

  def delete_resource
    pulp('rpm', 'distribution', 'destroy', '--name', resource[:name])
  end
end
