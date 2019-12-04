# @summary Install pulpcore packages
# Currently this is done with pip3. This should have the option to also install via RPMs.
# @api private
class pulpcore::install {

  $system_packages = ['gcc', 'postgresql-devel', 'python3-pip', 'python3-devel']

  ensure_packages($system_packages)

  package { 'pulpcore':
    ensure   => present,
    provider => 'pip3',
    require  => Package[$system_packages],
  }

  user { $pulpcore::user:
    ensure     => present,
    gid        => $pulpcore::group,
    home       => $pulpcore::user_home,
    managehome => false,
  }

  group { $pulpcore::group:
    ensure => present,
  }

}
