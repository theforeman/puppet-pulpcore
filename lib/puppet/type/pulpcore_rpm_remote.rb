# frozen_string_literal: true

require_relative '../../puppet_x/pulpcore/type_helpers'

Puppet::Type.newtype(:pulpcore_rpm_remote) do
  include PuppetX::Pulpcore::TypeHelpers

  ensurable

  newparam(:name, namevar: true)

  newproperty(:url) do
    desc 'The URL for the remote.'

    newvalue(%r{\A(https?|uln)://.+\z})
  end

  newproperty(:policy) do
    desc 'One of `immediate`, `on_demand` or `streamed`.'

    newvalue(%r{\A(immediate|on_demand|streamed)\z})
  end

  newproperty(:tls_validation) do
    munge { |value| @resource.munge_boolean_to_symbol(value) }
  end

  newproperty(:client_cert) do
    desc 'A PEM encoded client certificate used for authentication. When set, the `client_key` parameter must also be specified.  Set to `absent` to remove.'

    newvalue(:absent)
    newvalue(%r{\A-----BEGIN CERTIFICATE-----\n.+-----END CERTIFICATE-----\n?\z}m)

    # Pulp does not return the client_key value, but hidden_fields tells us
    # whether one is set. Treat the cert and hidden key as a pair for sync.
    def insync?(is)
      client_cert_in_sync = super(is)

      if should == :absent
        client_cert_in_sync && !resource.provider.client_key_set?
      else
        client_cert_in_sync && resource.provider.client_key_set?
      end
    end
  end

  # The Pulp API doesn't return the client_key, so it's not something we can check is 'in sync'.
  # As such, it's made a parameter here, not a _property_.
  newparam(:client_key) do
    desc 'A PEM encoded private key used for authentication. Required when `client_cert` is set, (and not `absent`).'

    newvalues(:absent, %r{\A-----BEGIN PRIVATE KEY-----\n.+-----END PRIVATE KEY-----\n?\z}m)
  end

  newproperty(:ca_cert) do
    desc 'A PEM encoded CA certificate used to validate the server certificate presented by the remote server.  Set to `absent` to remove.'

    newvalue(:absent)
    newvalue(%r{\A-----BEGIN CERTIFICATE-----\n.+-----END CERTIFICATE-----\n?\z}m)
  end

  validate do
    if self[:client_cert] && self[:client_cert] != :absent && (!self[:client_key] || self[:client_key] == :absent)
      raise Puppet::Error,
            'pulpcore_rpm_remote: `client_key` is required when `client_cert` is set.'
    end
  end

  private

  # client_key carries private key material, so always mark it sensitive. This
  # redacts it from logs, reports and `puppet resource` output even when the
  # user hasn't wrapped it in Sensitive() themselves.
  def set_sensitive_parameters(sensitive_parameters) # rubocop:disable Naming/AccessorMethodName
    parameter(:client_key).sensitive = true if parameter(:client_key)

    super(sensitive_parameters)
  end
end
