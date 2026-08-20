# frozen_string_literal: true

require_relative '../pulpcore_cli'
require_relative '../pulpcore_rpm_repo'

Puppet::Type.type(:pulpcore_rpm_repo).provide(:cli, parent: Puppet::Provider::PulpcoreRpmRepo) do
  include Puppet::Provider::PulpcoreCli

  def self.resource_api_hashes
    parse_pulp_json(pulp('rpm', 'repository', 'list', '--limit', 1_000_000))
  end

  def self.resource_api_hash(repo_name)
    parse_pulp_json(pulp('rpm', 'repository', 'show', '--name', repo_name))
  end

  def create_resource
    command_arguments = ['rpm', 'repository', 'create', '--name', resource[:name]]

    command_arguments << '--description' << resource[:description] if resource[:description] && resource[:description] != :absent

    command_arguments << '--remote' << resource[:remote] if resource[:remote] && resource[:remote] != :absent

    command_arguments << '--retain-package-versions' << resource[:retain_package_versions] if resource[:retain_package_versions]

    command_arguments << '--retain-repo-versions' << resource[:retain_repo_versions] if resource[:retain_repo_versions] && resource[:retain_repo_versions] != :absent

    case resource[:autopublish]
    when :true
      command_arguments << '--autopublish'
    when :false
      command_arguments << '--no-autopublish'
    end

    pulp(*command_arguments)
  end

  def update_resource
    command_arguments = ['rpm', 'repository', 'update', '--name', resource[:name]]

    command_arguments << '--description' << @property_flush[:description] if @property_flush.key?(:description)
    command_arguments << '--remote'      << @property_flush[:remote]      if @property_flush.key?(:remote)

    command_arguments << '--retain-package-versions' << @property_flush[:retain_package_versions] if @property_flush.key?(:retain_package_versions)

    command_arguments << '--retain-repo-versions' << @property_flush[:retain_repo_versions] if @property_flush.key?(:retain_repo_versions)

    case @property_flush[:autopublish]
    when :true
      command_arguments << '--autopublish'
    when :false
      command_arguments << '--no-autopublish'
    end

    pulp(*command_arguments)
  end

  def delete_resource
    pulp('rpm', 'repository', 'destroy', '--name', resource[:name])
  end
end
