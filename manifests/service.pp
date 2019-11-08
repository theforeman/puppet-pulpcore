# configure, enable, and start pulpcore services
# @api private
class pulpcore::service {

  systemd::unit_file { 'pulpcore-api.service':
    content => template('pulpcore/pulpcore-api.service.erb'),
    active  => true,
    enable  => true,
  }

  systemd::unit_file { 'pulpcore-content.service':
    content => template('pulpcore/pulpcore-content.service.erb'),
    active  => true,
    enable  => true,
  }

  systemd::unit_file { 'pulpcore-resource-manager.service':
    content => template('pulpcore/pulpcore-resource-manager.service.erb'),
    active  => true,
    enable  => true,
  }

  systemd::unit_file { 'pulpcore-worker@.service':
    content => template('pulpcore/pulpcore-worker@.service.erb'),
  }

  service { ['pulpcore-worker@1', 'pulpcore-worker@2']:
    ensure  => running,
    enable  => true,
    require => [Systemd::Unit_file['pulpcore-worker@.service'], Class['systemd::systemctl::daemon_reload']],
  }

}
