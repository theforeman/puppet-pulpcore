# @summary Install pulpcore packages, configure user and group
#
# @api private
class pulpcore::install {
  package { 'pulpcore':
    ensure => present,
  }

  if $facts['os']['selinux']['enabled'] {
    package { 'pulpcore-selinux':
      ensure => present,
    }
  }

  if $pulpcore::storage_backend != 'file' {
    # TODO: better virtual for this
    package { 'python3.11-django-storages':
      ensure => present,
    }
  }

  user { $pulpcore::user:
    ensure     => present,
    system     => true,
    gid        => $pulpcore::group,
    home       => $pulpcore::user_home,
    shell      => '/sbin/nologin',
    managehome => false,
  }

  group { $pulpcore::group:
    ensure => present,
    system => true,
  }
}
