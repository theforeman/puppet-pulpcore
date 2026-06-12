# frozen_string_literal: true

require_relative 'pulpcore'

# Abstract provider for Pulpcore RPM repository resources.
#
# This class contains behaviour common to all `pulpcore_rpm_repo` providers.
# Concrete implementations, such as the `cli` provider, inherit from it.
class Puppet::Provider::PulpcoreRpmRepo < Puppet::Provider::Pulpcore
  mk_property_hash_getters(
    :autopublish,
    :description,
    :remote,
    :retain_package_versions,
    :retain_repo_versions
  )
  mk_property_flush_setters(:autopublish, :retain_package_versions)
  mk_absent_clearing_setters(:description, :remote, :retain_repo_versions)

  def self.resource_properties_from_api_hash(repo_properties)
    resource_properties = {
      name: repo_properties['name'],
      ensure: :present,
      provider: name,

      description: repo_properties['description'] || :absent,
      remote: name_by_href(repo_properties['remote']),
      retain_package_versions: repo_properties['retain_package_versions'],
      retain_repo_versions: repo_properties['retain_repo_versions'] || :absent,
      autopublish: repo_properties['autopublish'] ? :true : :false
    }

    debug "Repository resource properties: #{resource_properties.inspect}"

    resource_properties
  end
end
