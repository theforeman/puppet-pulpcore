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
# @param postgresql_db_name
#   Name of Pulp database
#
# @param postgresql_db_password
#   Password of Pulp database
#
# @param django_secret_key
#   SECRET_KEY for Django
#
# @param redis_db
#   Redis DB number to use. By default, Redis supports a DB number of 0 through 15.
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
  String $postgresql_db_name = 'pulpcore',
  String $postgresql_db_password = extlib::cache_data('pulpcore_cache_data', 'db_password', extlib::random_password(32)),
  String $django_secret_key = extlib::cache_data('pulpcore_cache_data', 'secret_key', extlib::random_password(32)),
  Integer[0] $redis_db = 8,
) {

  $settings_file = "${config_dir}/settings.py"
  $servername = $facts['fqdn']

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
