# frozen_string_literal: true

require_relative 'pulpcore'

# Abstract provider for Pulpcore RPM distribution resources.
#
# This class contains behaviour common to all `pulpcore_rpm_distribution`
# providers. Concrete implementations, such as the `cli` provider, inherit
# from it.
class Puppet::Provider::PulpcoreRpmDistribution < Puppet::Provider::Pulpcore
  mk_property_hash_getters(
    :base_path,
    :repo,
    :checkpoint
  )
  mk_property_flush_setters(:base_path, :checkpoint)
  mk_absent_clearing_setters(:repo)

  def self.resource_properties_from_api_hash(distribution_properties)
    resource_properties = {
      name: distribution_properties['name'],
      ensure: :present,
      provider: name,

      base_path: distribution_properties['base_path'],
      repo: name_by_href(distribution_properties['repository']),
      checkpoint: distribution_properties['checkpoint'] ? :true : :false
    }

    debug "Distribution resource properties: #{resource_properties.inspect}"

    resource_properties
  end
end
