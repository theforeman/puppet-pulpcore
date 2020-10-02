# configure, enable, and start pulpcore services
# @api private
class pulpcore::service {
  include apache

  systemd::unit_file { 'pulpcore-api.socket':
    content => template('pulpcore/pulpcore-api.socket.erb'),
    active  => true,
    enable  => true,
  }

  systemd::unit_file { 'pulpcore-api.service':
    content => template('pulpcore/pulpcore-api.service.erb'),
    active  => true,
    enable  => true,
  }

  systemd::unit_file { 'pulpcore-content.socket':
    content => template('pulpcore/pulpcore-content.socket.erb'),
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

  Integer[1, $pulpcore::worker_count].each |$n| {
    service { "pulpcore-worker@${n}.service":
      ensure    => running,
      enable    => true,
      require   => Class['systemd::systemctl::daemon_reload'],
      subscribe => Systemd::Unit_file['pulpcore-worker@.service'],
    }
  }

  $existing_workers = fact('pulpcore_workers')
  if $existing_workers {
    $existing_workers.each |$worker| {
      if $worker =~ /^pulpcore-worker@\d+\.service$/ and !defined(Service[$worker]) {
        service { $worker:
          ensure  => stopped,
          enable  => false,
          require => [Systemd::Unit_file['pulpcore-worker@.service'], Class['systemd::systemctl::daemon_reload']],
        }
      }
    }
  }
}
