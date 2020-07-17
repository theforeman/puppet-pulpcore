# @summary Manage the static files (assets)
# @api private
class pulpcore::static {
  file { $pulpcore::static_root:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0755',
  }

  pulpcore::admin { 'collectstatic --noinput':
    refreshonly => true,
    subscribe   => Concat['pulpcore settings'],
    require     => File[$pulpcore::static_root],
  }
}
