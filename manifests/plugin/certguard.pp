# @summary Pulp Certguard plugin
class pulpcore::plugin::certguard {
  if $facts['os']['release']['major'] == '7' {
    package { 'python3-subscription-manager-rhsm':
      ensure => present,
    }
  }
  pulpcore::plugin { 'certguard':
  }
}
