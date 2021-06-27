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

  if $pulpcore::use_rq_tasking_system {
    systemd::unit_file { 'pulpcore-resource-manager.service':
      content => template('pulpcore/pulpcore-resource-manager.service.erb'),
      active  => $pulpcore::service_ensure,
      enable  => $pulpcore::service_enable,
    }
  } else {
    systemd::unit_file { 'pulpcore-resource-manager.service':
      ensure => 'absent',
      active => false,
      enable => false,
    }
  }

  systemd::unit_file { 'pulpcore-worker@.service':
    content => template('pulpcore/pulpcore-worker@.service.erb'),
  }

  # In camptocamp/systemd 3.0.0 support for Puppet < 6.1.0 was dropped.
  # This means there is no single daemon-reload class anymore. This also means
  # there is no more relation that ensures all services are loaded prior to running them.
  $metadata = load_module_metadata('systemd')
  if SemVer($metadata['version']) >= SemVer('3.0.0') {
    $reload_require = undef
  } else {
    $reload_require = Class['systemd::systemctl::daemon_reload']
  }

  Integer[1, $pulpcore::worker_count].each |$n| {
    service { "pulpcore-worker@${n}.service":
      ensure    => $pulpcore::service_ensure,
      enable    => $pulpcore::service_enable,
      require   => $reload_require,
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
          require => [Systemd::Unit_file['pulpcore-worker@.service'], $reload_require],
        }
      }
    }
  }
}
