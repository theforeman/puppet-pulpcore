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

  exec { 'django-admin collectstatic --noinput':
    path        => ['/usr/local/bin', '/usr/bin'],
    environment => [
      'DJANGO_SETTINGS_MODULE=pulpcore.app.settings',
      "PULP_SETTINGS=${pulpcore::settings_file}",
    ],
    refreshonly => true,
  }

}
