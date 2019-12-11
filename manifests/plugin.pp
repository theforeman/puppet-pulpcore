# @summary Install a plugin
#
# @param package_name
#   The package name to install
#
# @param config
#   An optional config in the Pulp settings file
define pulpcore::plugin(
  String $package_name = "python3-pulp-${title}",
  Optional[String] $config = undef,
) {
  package { $package_name:
    ensure => present,
  }

  if $config {
    concat::fragment { "plugin-${title}":
      target  => 'pulpcore settings',
      content => "\n# ${title} plugin settings\n${config}",
      order   => '10',
    }
  }
}
