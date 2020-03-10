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

$pulpcore_repo_conf = @("CONF")
[pulpcore]
baseurl=${baseurl}
gpgcheck=0
module_hotfixes=1
CONF

file { '/etc/yum.repos.d/pulpcore.repo':
  ensure  => file,
  content => $pulpcore_repo_conf,
}

# Needed as a workaround for idempotency
if $facts['os']['selinux']['enabled'] {
  package { 'pulpcore-selinux':
    ensure  => installed,
    require => File['/etc/yum.repos.d/pulpcore.repo'],
  }
}
