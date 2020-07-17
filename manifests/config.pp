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

  file { [$pulpcore::cache_dir, $pulpcore::chunked_upload_dir, $pulpcore::media_root]:
    ensure => directory,
    owner  => $pulpcore::user,
    group  => $pulpcore::group,
    mode   => '0750',
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
