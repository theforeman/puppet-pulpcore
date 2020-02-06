# @summary Pulp 2 to Pulp 3 Migration Plugin
#
# @param mongo_db_name
#   MongoDB database name for Pulp2. Used for migrating Pulp2 content
#
# @param mongo_db_seeds
#   MongoDB seeds. Used for migrating Pulp2 content
#
# @param mongo_db_username
#   MongoDB username for Pulp2
#
# @param mongo_db_password
#   Password of MongoDB user
#
# @param mongo_db_replica_set
#   MongoDB Replica Set
#
# @param mongo_db_ssl
#   Use SSL for MongoDB connection
#
# @param mongo_db_ssl_keyfile
#   SSL Keyfile for MongoDB
#
# @param mongo_db_ssl_certfile
#   SSL Certfile for MongoDB
#
# @param mongo_db_verify_ssl
#   Whether SSL verification is required for MongoDB
#
# @param mongo_db_ca_path
#   CA bundle path to use for MongoDB SSL connection
#
class pulpcore::plugin::migration (
  String $mongo_db_name = 'pulp_database',
  String $mongo_db_seeds = 'localhost:27017',
  Optional[String] $mongo_db_username = undef,
  Optional[String] $mongo_db_password = undef,
  Optional[String] $mongo_replica_set = undef,
  String $mongo_db_ssl = 'False',
  Optional[Stdlib::Absolutepath] $mongo_db_ssl_keyfile = undef,
  Optional[Stdlib::Absolutepath] $mongo_db_ssl_certfile = undef,
  String $mongo_db_verify_ssl = 'True',
  Stdlib::Absolutepath $mongo_db_ca_path = '/etc/pki/tls/certs/ca-bundle.crt',
) {
  pulpcore::plugin { 'migration':
    package_name => 'python3-pulp-2to3-migration',
    config       => template('pulpcore/migration-settings.py.erb'),
  }
}
