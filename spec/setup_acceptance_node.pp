$major = $facts['os']['release']['major']

case $major {
  '7': {
    package { 'centos-release-scl-rh':
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

# Defaults to staging, for release, use
# $baseurl = "https://fedorapeople.org/groups/katello/releases/yum/nightly/pulpcore/el${major}/x86_64/"
$baseurl = "http://koji.katello.org/releases/yum/katello-nightly/pulpcore/el${major}/x86_64/"

file { 'pulpcore-repo-extra-config':
  path    => '/etc/yum/pulpcore.conf',
  content => 'module_hotfixes=1',
  before  => Yumrepo['pulpcore'],
}

yumrepo { 'pulpcore':
  baseurl  => $baseurl,
  gpgcheck => 0,
  include  => 'file:///etc/yum/pulpcore.conf',
}

# Needed as a workaround for idempotency
if $facts['os']['selinux']['enabled'] {
  package { 'pulpcore-selinux':
    ensure  => installed,
    require => Yumrepo['pulpcore'],
  }
}
