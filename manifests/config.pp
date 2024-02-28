# Configures pulp3
# @api private
class pulpcore::config {
  if $pulpcore::redis_url {
    $redis_url = $pulpcore::redis_url
  } else {
    contain redis
    $redis_url = "redis://localhost:${redis::port}/${pulpcore::redis_db}"
  }

  file { [$pulpcore::config_dir, $pulpcore::certs_dir]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
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

  $loggers = {
    'pulpcore.deprecation' => {
      'level' => 'ERROR',
    },
    'django_guid'          => {
      'level' => 'WARNING',
    },
  } + $pulpcore::loggers

  concat::fragment { 'logging':
    target  => 'pulpcore settings',
    content => epp('pulpcore/settings-logging.py.epp', {
        'level'   => $pulpcore::log_level,
        'loggers' => $loggers,
    }),
    order   => '02',
  }

  file { $pulpcore::user_home:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0775',
  }

  file { [$pulpcore::cache_dir, $pulpcore::media_root]:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0750',
  }

  file { unique($pulpcore::allowed_import_path + $pulpcore::allowed_export_path):
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0770',
  }

  exec { 'Create database symmetric key':
    path    => ['/bin', '/usr/bin'],
    command => "openssl rand -base64 32 | tr '+/' '-_' > ${pulpcore::database_key_file}",
    creates => $pulpcore::database_key_file,
  }

  file { $pulpcore::database_key_file:
    owner   => 'root',
    group   => $pulpcore::group,
    mode    => '0640',
    require => Exec['Create database symmetric key'],
  }
}
