# @summary Pulp Certguard plugin
class pulpcore::plugin::certguard {
  package { 'python3-subscription-manager-rhsm':
    ensure => present,
  }
  -> pulpcore::plugin { 'certguard':
  }
}
