# Configures pulp3
# @api private
class pulpcore::config {
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

  file { $pulpcore::user_home:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0775',
  }

  file { $pulpcore::cache_dir:
    ensure  => directory,
    owner   => $pulpcore::user,
    group   => $pulpcore::group,
    mode    => '0750',
  }

  file { $pulpcore::media_root:
    ensure  => directory,
    owner   => $pulpcore::user,
    group   => $pulpcore::group,
    mode    => '0750',
    recurse => true,
  }

  file { $pulpcore::allowed_import_path:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0770',
  }

  file { $pulpcore::allowed_export_path:
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
