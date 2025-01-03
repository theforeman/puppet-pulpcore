# = Pulpcore command line interface
#
# This class installs the Pulpcore command line interface (CLI).
#
# === Parameters:
#
# $pulpcore_url::       URL on which Pulpcore runs
#
# $username::           Username for authentication
#
# $password::           Password for authentication
#
# $cert::               Client certificate for authentication
#
# $key::                Client key for authentication
#
# === Advanced parameters:
#
# $manage_root_config:: Whether to manage /root/.config/pulp configuration.
#
# $api_root::           Absolute API base path on server (not including 'api/v3/')
#
# $verify_ssl::         Verify SSL connection
#
# $dry_run::            Trace commands without performing any unsafe HTTP calls
#
# $version::            pulp-cli package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
class pulpcore::cli (
  Optional[Stdlib::HTTPUrl] $pulpcore_url = undef,
  String $version = 'installed',
  Optional[String] $username = undef,
  Optional[Variant[Sensitive[String], String]] $password = undef,
  Optional[String] $cert = undef,
  Optional[String] $key = undef,
  Optional[String] $api_root = undef,
  Boolean $verify_ssl = true,
  Boolean $dry_run = true,
  Boolean $manage_root_config = true,
) {
  package { 'pulp-cli':
    ensure => $version,
  }
  -> file { '/etc/pulp/cli.toml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp(
      'pulpcore/cli-config.toml.epp',
      {
        base_url   => $pulpcore_url,
        api_root   => $api_root,
        verify_ssl => $verify_ssl,
        dry_run    => $dry_run,
      }
    ),
  }

  if $manage_root_config and (($username and $password) or ($cert and $key)) {
    file { '/root/.config':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
    file { '/root/.config/pulp':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0600',
    }
    file { '/root/.config/pulp/cli.toml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => epp(
        'pulpcore/cli-config.toml.epp',
        {
          username => $username,
          password => $password,
          cert     => $cert,
          key      => $key,
        }
      ),
    }
  }

  Anchor <| title == 'pulpcore::repo' |> ~> Package <| tag == 'pulpcore::cli' |>
}
