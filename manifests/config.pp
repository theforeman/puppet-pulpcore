# Configures pulp3
# @api private
class pulpcore::config {
  file { $pulpcore::config_dir:
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

  if $redis::unixsocket != '' {
    $redis_url = "redis+unix://${redis::unixsocket}?db=${pulpcore::redis_db}"
  } elsif $redis::port != 0 {
    # TODO: this assumes $redis::bind at least has localhost in it
    $redis_url = "redis://localhost:${redis::port}/${pulpcore::redis_db}"
  } else {
    fail('Unable to determine Redis URL')
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

  file { [$pulpcore::cache_dir, $pulpcore::media_root]:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0750',
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

}
