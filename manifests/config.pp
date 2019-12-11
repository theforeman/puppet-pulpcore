# Configures pulp3
# @api private
class pulpcore::config {
  file { $pulpcore::config_dir:
    ensure => directory,
  }

  file { $pulpcore::settings_file:
    ensure  => file,
    owner   => 'root',
    group   => $pulpcore::group,
    mode    => '0640',
    content => template('pulpcore/settings.py.erb'),
  }

  file { [$pulpcore::user_home, $pulpcore::webserver_static_dir, $pulpcore::cache_dir]:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0755',
  }

  pulpcore::admin { 'collectstatic --noinput':
    refreshonly => true,
    subscribe   => File[$pulpcore::settings_file],
  }

}
