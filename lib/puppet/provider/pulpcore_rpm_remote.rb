# frozen_string_literal: true

require_relative 'pulpcore'

# Abstract provider for Pulpcore RPM remote resources.
#
# This class contains behaviour common to all `pulpcore_rpm_remote` providers.
# Concrete implementations, such as the `cli` provider, inherit from it.
class Puppet::Provider::PulpcoreRpmRemote < Puppet::Provider::Pulpcore
  mk_property_hash_getters(
    :url,
    :policy,
    :tls_validation,
    :client_cert,
    :ca_cert
  )
  mk_property_flush_setters(:url, :policy, :tls_validation)
  mk_absent_clearing_setters(:client_cert, :ca_cert)

  def self.resource_properties_from_api_hash(remote_properties)
    resource_properties = {
      name: remote_properties['name'],
      ensure: :present,
      provider: name,

      url: remote_properties['url'],
      policy: remote_properties['policy'],
      tls_validation: remote_properties['tls_validation'] ? :true : :false,

      client_cert: remote_properties['client_cert'] || :absent,
      ca_cert: remote_properties['ca_cert'] || :absent,

      # Internal provider state, not a Puppet property.
      client_key_set: hidden_field_set?(remote_properties, 'client_key')
    }

    debug "Remote resource properties: #{resource_properties.inspect}"

    resource_properties
  end

  # Pulp never returns secret values (such as client_key) in an API response.
  # Instead each appears in the `hidden_fields` array with an `is_set` flag
  # reporting whether a value is currently stored. Return that flag for the
  # named field, raising if the response isn't shaped as expected.
  def self.hidden_field_set?(api_hash, field_name)
    hidden_fields = api_hash.fetch('hidden_fields') do
      raise Puppet::Error, 'Pulp API response did not include hidden_fields.'
    end

    raise Puppet::Error, 'Pulp API response hidden_fields was nil.' if hidden_fields.nil?

    hidden_field = hidden_fields.find do |field|
      field['name'] == field_name
    end

    raise Puppet::Error, "Pulp API response did not include #{field_name} in hidden_fields." unless hidden_field

    hidden_field['is_set']
  end

  def client_key_set?
    @property_hash[:client_key_set] == true
  end
end
