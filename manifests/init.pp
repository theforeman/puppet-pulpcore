# Manage your next generation Pulp server
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
# @param apache_http_vhost
#   When true, deploy a separate apache vhost for pulp3 listening on HTTP.
#   When a name is given, fragments are attached to the specified vhost.
#   When false, no Apache HTTP vhost is touched.
#
# @param apache_https_vhost
#   When true, deploy a separate apache vhost for pulp3 listening on HTTPS.
#   When a name is given, fragments are attached to the specified vhost.
#   When false, no Apache HTTPS vhost is touched.
#
# @param apache_https_cert
#   The certificate file to use in the HTTPS vhost. Only used when
#   apache_https_vhost is true.
#
# @param apache_https_key
#   The key file to use in the HTTPS vhost. Only used when apache_https_vhost
#   is true.
#
# @param apache_https_ca
#   The ca file to use in the HTTPS vhost. Only used when apache_https_vhost is
#   true. The ca file should contain the certificates allowed to sign client
#   certificates. This can be a different CA than the chain.
#
# @param apache_https_chain
#   The chain file to use in the HTTPS vhost. Only used when apache_https_vhost
#   is true. The chain file should contain the CA certificate an any
#   intermediate certificates that signed the certificate.
#
# @param apache_vhost_priority
#   The Apache vhost priority. When a name is passed to apache_http_vhost or
#   apache_https_vhost, this will be used when attaching fragments to those
#   vhosts. Note that this implies both vhosts need to have the same priority.
#
# @param api_socket_path
#   Path where the Pulpcore API service is listening. This is a unix socket.
#
# @param content_socket_path
#   Path where the Pulpcore Content service is listening. This is a unix socket.
#
# @param config_dir
#   Pulp configuration directory. The settings.py file is created under this
#   directory.
#
# @param cache_dir
#   Pulp cache directory. This is used to configure WORKING_DIRECTORY and
#   FILE_UPLOAD_TEMP_DIR.
#
# @param apache_docroot
#   Root directory for the Apache vhost. Only created if the Apache vhost is
#   managed by this module.
#
# @param media_root
#   Directory for Pulp's uploaded media. This corresponds to the MEDIA_ROOT
#   setting.
#
# @param static_root
#   Root directory for collected static content. This corresponds to the
#   STATIC_ROOT setting.
#
# @param static_url
#   The "URL" that serves the collected static content. This corresponds to the
#   STATIC_URL setting. In reality this can also be just the path and doesn't
#   have to be a full URL.
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
# @param allowed_import_path
#   Allowed paths that pulp can use for content imports, or sync from using file:// protocol
#
# @param allowed_export_path
#   Allowed paths that pulp can use for content exports
#
# @param allowed_content_checksums
#   List of checksum types to allow for content operations
#
# @param worker_count
#   Number of pulpcore workers. Defaults to 8 or the number of CPU cores, whichever is smaller. Enabling more than 8 workers, even with additional CPU cores
#   available, likely results in performance degradation due to I/O blocking and is not recommended in most cases. Modifying this parameter should
#   be done incrementally with benchmarking at each step to determine an optimal value for your deployment.
#
# @param use_rq_tasking_system
#   Use the older RQ workers tasking system instead of the newer PostgreSQL tasking system introduced in Pulpcore 3.14.
#   Any benchmarking you did to optimize worker_count or other tasking related parameters will no longer be accurate after changing the tasking system.
#   Do not modify this setting unless you understand the implications for performance and stability.
#
# @param service_enable
#   Enable/disable Pulp services at boot.
#
# @param service_ensure
#   Specify if Pulp services should be running or stopped.
#
# @param content_service_worker_count
#   Number of pulpcore-content service workers for gunicorn to use.
#   Modifying this parameter should be done incrementally with benchmarking at each step to determine an optimal value for your deployment.
#
# @param api_service_worker_count
#   Number of pulpcore-api service workers for gunicorn to use.
#   Modifying this parameter should be done incrementally with benchmarking at each step to determine an optimal value for your deployment.
#
# @param content_service_worker_timeout
#   Timeout in seconds of the pulpcore-content gunicorn workers.
#
# @param api_service_worker_timeout
#   Timeout in seconds of the pulpcore-api gunicorn workers.
#
# @param api_client_auth_cn_map
#   Mapping of certificate common name and Pulp user to authenticate to Pulp API.
#
# @param cache_enabled
#   Enables Redis based content caching within the Pulp content app.
#
# @param cache_expires_ttl
#   The number of seconds that content should be cached for. Specify 'None' to never expire the cache.
#
# @example Default configuration
#   include pulpcore
#
# @see https://docs.djangoproject.com/en/2.2/howto/static-files/
class pulpcore (
  String $user = 'pulp',
  String $group = 'pulp',
  Stdlib::Absolutepath $user_home = '/var/lib/pulp',
  Stdlib::Absolutepath $config_dir = '/etc/pulp',
  Stdlib::Absolutepath $cache_dir = '/var/lib/pulp/tmp',
  Stdlib::Absolutepath $media_root = '/var/lib/pulp/media',
  Stdlib::Absolutepath $static_root = '/var/lib/pulp/assets',
  Pattern['^/.+/$'] $static_url = '/assets/',
  Stdlib::Absolutepath $apache_docroot = '/var/lib/pulp/pulpcore_static',
  Variant[Boolean, String[1]] $apache_http_vhost = true,
  Variant[Boolean, String[1]] $apache_https_vhost = true,
  Optional[Stdlib::Absolutepath] $apache_https_cert = undef,
  Optional[Stdlib::Absolutepath] $apache_https_key = undef,
  Optional[Stdlib::Absolutepath] $apache_https_ca = undef,
  Optional[Stdlib::Absolutepath] $apache_https_chain = undef,
  String[1] $apache_vhost_priority = '10',
  Stdlib::Absolutepath $api_socket_path = '/run/pulpcore-api.sock',
  Stdlib::Absolutepath $content_socket_path = '/run/pulpcore-content.sock',
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
  String $django_secret_key = extlib::cache_data('pulpcore_cache_data', 'secret_key', extlib::random_password(50)),
  Integer[0] $redis_db = 8,
  Stdlib::Fqdn $servername = $facts['networking']['fqdn'],
  Array[Stdlib::Absolutepath] $allowed_import_path = ['/var/lib/pulp/sync_imports'],
  Array[Stdlib::Absolutepath] $allowed_export_path = [],
  Pulpcore::ChecksumTypes $allowed_content_checksums = ['sha224', 'sha256', 'sha384', 'sha512'],
  String[1] $remote_user_environ_name = 'HTTP_REMOTE_USER',
  Integer[0] $worker_count = min(8, $facts['processors']['count']),
  Boolean $use_rq_tasking_system = false,
  Boolean $service_enable = true,
  Boolean $service_ensure = true,
  Integer[0] $content_service_worker_count = (2*min(8, $facts['processors']['count']) + 1),
  Integer[0] $api_service_worker_count = 1,
  Integer[0] $content_service_worker_timeout = 90,
  Integer[0] $api_service_worker_timeout = 90,
  Hash[String[1], String[1]] $api_client_auth_cn_map = {},
  Boolean $cache_enabled = false,
  Optional[Variant[Integer[1], Enum['None']]] $cache_expires_ttl = undef,
) {
  $settings_file = "${config_dir}/settings.py"

  contain pulpcore::install
  contain pulpcore::database
  contain pulpcore::config
  contain pulpcore::static
  contain pulpcore::service
  contain pulpcore::apache

  Anchor <| title == 'pulpcore::repo' |> ~> Class['pulpcore::install']
  Class['pulpcore::install'] ~> Class['pulpcore::config', 'pulpcore::database', 'pulpcore::service']
  Class['pulpcore::config'] ~> Class['pulpcore::database', 'pulpcore::static', 'pulpcore::service']
  Class['pulpcore::database', 'pulpcore::static'] -> Class['pulpcore::service'] -> Class['pulpcore::apache']

  # lint:ignore:spaceship_operator_without_tag
  Class['pulpcore::install']
  ~> Pulpcore::Plugin <| |>
  ~> Class['pulpcore::database', 'pulpcore::service']
  # lint:endignore
}
