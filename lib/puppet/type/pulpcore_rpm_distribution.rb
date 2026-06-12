# frozen_string_literal: true

require_relative '../../puppet_x/pulpcore/type_helpers'

Puppet::Type.newtype(:pulpcore_rpm_distribution) do
  include PuppetX::Pulpcore::TypeHelpers

  ensurable

  newparam(:name, namevar: true)

  newproperty(:base_path) do
    desc 'The base path component of the URL at which the distribution is served.'

    newvalue(%r{\A.+\z})
  end

  newproperty(:repo) do
    desc 'The name of the repository to be used for auto-distributing.  Set to `absent` to remove.'

    newvalue(:absent)
    newvalue(%r{\A.+\z})
  end

  newproperty(:checkpoint) do
    desc 'Whether this distribution should host `checkpoint` publications or not.'

    munge { |value| @resource.munge_boolean_to_symbol(value) }
  end

  autorequire(:pulpcore_rpm_repo) do
    if self[:repo] && self[:repo] != :absent
      [self[:repo]]
    else
      []
    end
  end
end
