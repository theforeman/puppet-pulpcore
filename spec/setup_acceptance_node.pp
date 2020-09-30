$major = $facts['os']['release']['major']

case $major {
  '7': {
    package { 'centos-release-scl-rh':
      ensure => installed,
    }

    package { 'epel-release':
      ensure => installed,
    }

    package { 'rh-redis5-redis':
      ensure  => installed,
      require => Package['centos-release-scl-rh'],
    }
  }
  '8': {
    package { 'glibc-langpack-en':
      ensure => installed,
    }
  }
  default: {}
}

class { 'pulpcore::repo':
  version => fact('pulpcore_version'),
}

# Needed as a workaround for idempotency
if $facts['os']['selinux']['enabled'] {
  package { 'pulpcore-selinux':
    ensure  => installed,
    require => Class['pulpcore::repo'],
  }
}
