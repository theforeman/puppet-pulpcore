# @summary Install pulpcore packages, configure user and group
#
# @api private
class pulpcore::install {

  package { 'python3-pulpcore':
    ensure => present,
  }

  if $facts['os']['selinux']['enabled'] {
    package { 'pulpcore-selinux':
      ensure => present,
    }
  }

  user { $pulpcore::user:
    ensure     => present,
    gid        => $pulpcore::group,
    home       => $pulpcore::user_home,
    managehome => false,
  }

  group { $pulpcore::group:
    ensure => present,
  }
}
