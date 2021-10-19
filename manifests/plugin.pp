# @summary Install a plugin
#
# @param package_name
#   The package name to install
#
# @param config
#   An optional config in the Pulp settings file
#
# @param http_content
#   Optional fragment for the Apache HTTP vhost
#
# @param https_content
#   Optional fragment for the Apache HTTPS vhost
define pulpcore::plugin(
  String $package_name = "pulpcore-plugin(${title})",
  Optional[String] $config = undef,
  Optional[String] $http_content = undef,
  Optional[String] $https_content = undef,
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

  if $http_content or $https_content {
    pulpcore::apache::fragment { "plugin-${title}":
      http_content  => $http_content,
      https_content => $https_content,
    }
  }
}
