# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database (
  Integer[0] $timeout = 3600,
) {
  if $pulpcore::postgresql_manage_db {
    include postgresql::client
    include postgresql::server
    include postgresql::server::contrib
    postgresql::server::db { $pulpcore::postgresql_db_name:
      user     => $pulpcore::postgresql_db_user,
      password => postgresql::postgresql_password($pulpcore::user, $pulpcore::postgresql_db_password),
      encoding => 'utf8',
      locale   => 'en_US.utf8',
      before   => Pulpcore::Admin['migrate --noinput'],
    }

    postgresql::server::extension { "hstore for ${pulpcore::postgresql_db_name}":
      database  => $pulpcore::postgresql_db_name,
      extension => 'hstore',
      require   => Class['postgresql::server::contrib'],
    }

    # pulpcore-content fails to reconnect to the database, so schedule a restart whenever the db changes
    # see https://pulp.plan.io/issues/9276 for details
    Class['postgresql::server::service'] ~> Service['pulpcore-content.service']
  }

  pulpcore::admin { 'migrate --noinput':
    timeout     => $timeout,
    unless      => 'pulpcore-manager migrate --plan | grep "No planned migration operations"',
    refreshonly => false,
  }

  pulpcore::admin { 'reset-admin-password --random':
    unless      => 'pulpcore-manager dumpdata auth.User | grep "\"username\": \"admin\""',
    refreshonly => false,
    require     => Pulpcore::Admin['migrate --noinput'],
  }

  contain redis
}
