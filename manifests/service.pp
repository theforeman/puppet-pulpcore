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

  # In camptocamp/systemd 3.0.0 support for Puppet < 6.1.0 was dropped.
  # This means there is no single daemon-reload class anymore. This also means
  # there is no more relation that ensures all services are loaded prior to running them.
  $metadata = load_module_metadata('systemd')
  if SemVer($metadata['version']) >= SemVer('3.0.0') {
    Systemd::Unit_file['pulpcore-api.socket']  -> Systemd::Unit_file['pulpcore-api.service']
    Systemd::Unit_file['pulpcore-content.socket']  -> Systemd::Unit_file['pulpcore-content.service']
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
