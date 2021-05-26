# configure, enable, and start pulpcore services
# @api private
class pulpcore::service {
  include apache
  $socket_service_ensure = bool2str($pulpcore::service_ensure, 'running', 'stopped')

  pulpcore::socket_service { 'pulpcore-api':
    ensure          => $socket_service_ensure,
    enable          => $pulpcore::service_enable,
    socket_content  => template('pulpcore/pulpcore-api.socket.erb'),
    service_content => template('pulpcore/pulpcore-api.service.erb'),
  }

  pulpcore::socket_service { 'pulpcore-content':
    ensure          => $socket_service_ensure,
    enable          => $pulpcore::service_enable,
    socket_content  => template('pulpcore/pulpcore-content.socket.erb'),
    service_content => template('pulpcore/pulpcore-content.service.erb'),
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
