# Manage your next generation Pulp server
#
# @param cache_dir
#   Pulp cache directory
#
# @param config_dir
#   Pulp configuration directory
#
# @param user
#   Pulp user
#
# @param group
#   Pulp user group
#
# @param user_home
#   Pulp user home directory
#
# @param manage_apache
#   Deploy a separate apache vhost for pulp3
#
# @param api_host
#   API service host
#
# @param api_port
#   API service port
#
# @param content_host
#   Content service host
#
# @param content_port
#   Content service port
#
# @param webserver_static_dir
#   Directory for Pulp webserver static content
#
# @param pulp_static_root
#   Root directory for collected static content
#
# @param postgresql_db_name
#   Name of Pulp PostgreSQL database
#
# @param postgresql_db_user
#   Pulp PostgreSQL database user
#
# @param postgresql_db_password
#   Password of Pulp PostgreSQL database
#
# @param postgresql_db_host
#   Host to connect to Pulp PostgreSQL database
#
# @param postgresql_db_port
#   Port to connect to Pulp PostgreSQL database
#
# @param postgresql_manage_db
#   Whether or not to manage the PostgreSQL installation. If false, a database at the specified host and port is expected to exist and the user should have sufficient permissions.
#
# @param postgresql_db_ssl
#   Whether to configure SSL connection for PostgresQL database. The configuration is only applied if the PostgresQL database is unmanaged.
#
# @param postgresql_db_ssl_require
#   Specifies whether pulpcore is configured to require an encrypted connection to the unmanaged PostgreSQL database server.
#
# @param postgresql_db_ssl_cert
#   Path to the SSL certificate to be used for the SSL connection to PostgreSQL.
#
# @param postgresql_db_ssl_key
#   Path to the key to be used for the SSL connection to PostgreSQL.
#
# @param postgresql_db_ssl_root_ca
#   Path to the root certificate authority to validate the certificate supplied by the PostgreSQL database server.
#
# @param django_secret_key
#   SECRET_KEY for Django
#
# @param redis_db
#   Redis DB number to use. By default, Redis supports a DB number of 0 through 15.
#
# @param servername
#   Server name of the VirtualHost in the webserver
#
# @param remote_user_environ_name
#   Django remote user environment variable
#
# @example
#   include pulpcore
class pulpcore (
  Stdlib::Absolutepath $cache_dir = '/var/lib/pulp/tmp',
  Stdlib::Absolutepath $config_dir = '/etc/pulp',
  String $user = 'pulp',
  String $group = 'pulp',
  Stdlib::Absolutepath $user_home = '/var/lib/pulp',
  Boolean $manage_apache = true,
  Stdlib::Host $api_host = '127.0.0.1',
  Stdlib::Port $api_port = 24817,
  Stdlib::Host $content_host = '127.0.0.1',
  Stdlib::Port $content_port = 24816,
  Stdlib::Absolutepath $webserver_static_dir = '/var/lib/pulp/docroot',
  Stdlib::Absolutepath $pulp_static_root = '/var/lib/pulp/assets',
  String $postgresql_db_name = 'pulpcore',
  String $postgresql_db_user = 'pulp',
  String $postgresql_db_password = extlib::cache_data('pulpcore_cache_data', 'db_password', extlib::random_password(32)),
  Stdlib::Host $postgresql_db_host = 'localhost',
  Stdlib::Port $postgresql_db_port = 5432,
  Boolean $postgresql_manage_db = true,
  Boolean $postgresql_db_ssl = false,
  Optional[Boolean] $postgresql_db_ssl_require = undef,
  Optional[Stdlib::Absolutepath] $postgresql_db_ssl_cert = undef,
  Optional[Stdlib::Absolutepath] $postgresql_db_ssl_key = undef,
  Optional[Stdlib::Absolutepath] $postgresql_db_ssl_root_ca = undef,
  String $django_secret_key = extlib::cache_data('pulpcore_cache_data', 'secret_key', extlib::random_password(32)),
  Integer[0] $redis_db = 8,
  Stdlib::Fqdn $servername = $facts['fqdn'],
  Optional[String] $remote_user_environ_name = undef,
) {

  $settings_file = "${config_dir}/settings.py"

  contain pulpcore::install
  contain pulpcore::database
  contain pulpcore::config
  contain pulpcore::service
  contain pulpcore::apache

  Class['pulpcore::install'] ~> Class['pulpcore::config', 'pulpcore::database', 'pulpcore::service']
  Class['pulpcore::config'] ~> Class['pulpcore::database', 'pulpcore::service']
  Class['pulpcore::database'] -> Class['pulpcore::service'] -> Class['pulpcore::apache']

  # lint:ignore:spaceship_operator_without_tag
  Class['pulpcore::install']
  ~> Pulpcore::Plugin <| |>
  ~> Class['pulpcore::database', 'pulpcore::service']
  # lint:endignore
}
