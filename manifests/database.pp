# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database {
  include postgresql::client
  include postgresql::server
  postgresql::server::db { $pulpcore::postgresql_db_name:
    user     => $pulpcore::user,
    password => postgresql_password($pulpcore::user, $pulpcore::postgresql_db_password),
  }

  pulpcore::admin { 'migrate --noinput':
    unless      => 'python3-django-admin migrate --plan | grep "No planned migration operations"',
    refreshonly => false,
    require     => Postgresql::Server::Db[$pulpcore::postgresql_db_name],
  }

  include redis

}
