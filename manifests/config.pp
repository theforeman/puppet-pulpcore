# Configures pulp3
# @api private
class pulpcore::config {
  file { $pulpcore::pulp_config_dir:
    ensure => directory,
  }

  file { $pulpcore::settings_file:
    ensure  => file,
    owner   => 'root',
    group   => $pulpcore::pulp_group,
    mode    => '0640',
    content => template('pulpcore/settings.py.erb'),
  }

  file { [$pulpcore::pulp_user_home, $pulpcore::pulp_webserver_static_dir, $pulpcore::pulp_cache_dir]:
    ensure => directory,
    owner  => $pulpcore::pulp_user,
    group  => $pulpcore::pulp_group,
    mode   => '0755',
  }

  exec { 'django-admin collectstatic':
    path        => ['/usr/local/bin', '/usr/bin'],
    environment => [
      'DJANGO_SETTINGS_MODULE=pulpcore.app.settings',
      "PULP_SETTINGS=${pulpcore::settings_file}",
    ],
    refreshonly => true,
  }

}
