# Set up the PostgreSQL and Redis databases
# @api private
class pulpcore::database {
  if $pulpcore::postgresql_manage_db {
    include postgresql::client
    include postgresql::server
    postgresql::server::db { $pulpcore::postgresql_db_name:
      user     => $pulpcore::postgresql_db_user,
      password => postgresql_password($pulpcore::user, $pulpcore::postgresql_db_password),
      before   => Pulpcore::Admin['migrate --noinput'],
    }
  }

  pulpcore::admin { 'migrate --noinput':
    unless      => 'python3-django-admin migrate --plan | grep "No planned migration operations"',
    refreshonly => false,
  }

  include redis

}
