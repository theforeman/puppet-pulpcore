# @summary Install pulpcore packages
# Currently this is done with pip3. This should have the option to also install via RPMs.
# @api private
class pulpcore::install {

  package { 'python3-pulpcore':
    ensure => present,
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
