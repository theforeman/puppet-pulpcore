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

  $dirs = unique([
      $pulpcore::user_home,
      $pulpcore::apache_docroot,
      $pulpcore::pulpcore_static_root,
      $pulpcore::pulpcore_media_root,
      $pulpcore::cache_dir,
  ])

  file { $dirs:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0775',
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
