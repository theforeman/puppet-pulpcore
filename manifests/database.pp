# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database (
  Integer[0] $timeout = 3600,
  Boolean $always_run_migrations = true,
) {
  if $pulpcore::postgresql_manage_db {
    include postgresql::client
    include postgresql::server
    include postgresql::server::contrib
    ensure_packages(['glibc-langpack-en'])
    postgresql::server::db { $pulpcore::postgresql_db_name:
      user     => $pulpcore::postgresql_db_user,
      password => postgresql::postgresql_password($pulpcore::postgresql_db_user, $pulpcore::postgresql_db_password),
      encoding => 'utf8',
      locale   => 'en_US.utf8',
      before   => Pulpcore::Admin['migrate --noinput'],
      require  => Package['glibc-langpack-en'],
    }

    postgresql::server::extension { "hstore for ${pulpcore::postgresql_db_name}":
      database  => $pulpcore::postgresql_db_name,
      extension => 'hstore',
      require   => Class['postgresql::server::contrib'],
    }

    postgresql::server::extension { "amcheck for ${pulpcore::postgresql_db_name}":
      database  => $pulpcore::postgresql_db_name,
      extension => 'amcheck',
      require   => Class['postgresql::server::contrib'],
    }

    # pulpcore-content fails to reconnect to the database, so schedule a restart whenever the db changes
    # see https://pulp.plan.io/issues/9276 for details
    Class['postgresql::server::service'] ~> Service['pulpcore-content.service']
  }

  # By default we want to always run `migrate`, even if `--check` returns no pending migrations
  # This is due to the fact that Pulp uses post_migration hooks that need to be executed even
  # when no real migration has happened.
  $migrate_unless = $always_run_migrations ? {
    false   => 'pulpcore-manager migrate --check',
    default => undef,
  }

  pulpcore::admin { 'migrate --noinput':
    timeout     => $timeout,
    unless      => $migrate_unless,
    refreshonly => false,
  }

  pulpcore::admin { 'reset-admin-password --random':
    unless      => 'pulpcore-manager dumpdata auth.User | grep "\"username\": \"admin\""',
    refreshonly => false,
    require     => Pulpcore::Admin['migrate --noinput'],
  }
}
