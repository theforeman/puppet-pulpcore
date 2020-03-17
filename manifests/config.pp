# Configures pulp3
# @api private
class pulpcore::config {
  file { $pulpcore::config_dir:
    ensure => directory,
  }

  concat { 'pulpcore settings':
    ensure         => present,
    path           => $pulpcore::settings_file,
    owner          => 'root',
    group          => $pulpcore::group,
    mode           => '0640',
    ensure_newline => true,
  }

  concat::fragment { 'base':
    target  => 'pulpcore settings',
    content => template('pulpcore/settings.py.erb'),
    order   => '01',
  }

  file { [$pulpcore::user_home, $pulpcore::webserver_static_dir, $pulpcore::cache_dir]:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0775',
  } ~> exec { "restorecon -RvF ${pulpcore::cache_dir}":
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => "restorecon -RvF ${pulpcore::cache_dir}",
    refreshonly => true,
  }

  pulpcore::admin { 'collectstatic --noinput':
    refreshonly => true,
    subscribe   => Concat['pulpcore settings'],
  }

  selinux::port { 'pulpcore-api-port':
    ensure   => 'present',
    seltype  => 'pulpcore_port_t',
    protocol => 'tcp',
    port     => $pulpcore::api_port,
  }

  selinux::port { 'pulpcore-content-port':
    ensure   => 'present',
    seltype  => 'pulpcore_port_t',
    protocol => 'tcp',
    port     => $pulpcore::content_port,
  }
}
