# configure, enable, and start pulpcore services
# @api private
class pulpcore::service {
  include apache

  systemd::unit_file { 'pulpcore-api.socket':
    content => template('pulpcore/pulpcore-api.socket.erb'),
    active  => $pulpcore::service_ensure,
    enable  => $pulpcore::service_enable,
  }

  systemd::unit_file { 'pulpcore-api.service':
    content => template('pulpcore/pulpcore-api.service.erb'),
    active  => $pulpcore::service_ensure,
    enable  => $pulpcore::service_enable,
  }

  systemd::unit_file { 'pulpcore-content.socket':
    content => template('pulpcore/pulpcore-content.socket.erb'),
    active  => $pulpcore::service_ensure,
    enable  => $pulpcore::service_enable,
  }

  systemd::unit_file { 'pulpcore-content.service':
    content => template('pulpcore/pulpcore-content.service.erb'),
    active  => $pulpcore::service_ensure,
    enable  => $pulpcore::service_enable,
  }

  systemd::unit_file { 'pulpcore-resource-manager.service':
    content => template('pulpcore/pulpcore-resource-manager.service.erb'),
    active  => $pulpcore::service_ensure,
    enable  => $pulpcore::service_enable,
  }

  systemd::unit_file { 'pulpcore-worker@.service':
    content => template('pulpcore/pulpcore-worker@.service.erb'),
  }

  Integer[1, $pulpcore::worker_count].each |$n| {
    service { "pulpcore-worker@${n}.service":
      ensure    => $pulpcore::service_ensure,
      enable    => $pulpcore::service_enable,
      require   => Class['systemd::systemctl::daemon_reload'],
      subscribe => Systemd::Unit_file['pulpcore-worker@.service'],
    }
  }

  $existing_workers = fact('pulpcore_workers')
  if $existing_workers {
    $existing_workers.each |$worker| {
      if $worker =~ /^pulpcore-worker@\d+\.service$/ and !defined(Service[$worker]) {
        service { $worker:
          ensure  => false,
          enable  => false,
          require => [Systemd::Unit_file['pulpcore-worker@.service'], Class['systemd::systemctl::daemon_reload']],
        }
      }
    }
  }
}
