# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database {
  include postgresql::client
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
    require     => Postgresql::Server::Db[$pulpcore::postgresql_db_name],
    unless      => 'django-admin migrate --plan | grep "No planned migration operations"',
  }

  include redis

}
