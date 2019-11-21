# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database {

  class { 'postgresql::globals':
    version              => '10',
    client_package_name  => 'rh-postgresql10-postgresql-syspaths',
    server_package_name  => 'rh-postgresql10-postgresql-server-syspaths',
    contrib_package_name => 'rh-postgresql10-postgresql-contrib-syspaths',
    service_name         => 'postgresql',
    datadir              => '/var/lib/pgsql/data',
    confdir              => '/var/lib/pgsql/data',
    bindir               => '/usr/bin',
  }

  include postgresql::server
  postgresql::server::db { $pulpcore::postgresql_db_name:
    user     => $pulpcore::user,
    password => postgresql_password($pulpcore::user, $pulpcore::postgresql_db_password),
  }

  exec { 'django-admin migrate --noinput':
    path        => ['/usr/local/bin', '/usr/bin'],
    environment => [
      'DJANGO_SETTINGS_MODULE=pulpcore.app.settings',
      "PULP_SETTINGS=${pulpcore::settings_file}",
    ],
    refreshonly => true,
    require     => Postgresql::Server::Db[$pulpcore::postgresql_db_name],
  }

  include redis

}
