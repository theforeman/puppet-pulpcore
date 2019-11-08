# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include pulpcore
class pulpcore (
  Stdlib::Absolutepath $pulp_cache_dir = '/var/lib/pulpcore/tmp',
  Stdlib::Absolutepath $pulp_config_dir = '/etc/pulpcore',
  String $pulp_user = 'pulpcore',
  String $pulp_group = 'pulpcore',
  Stdlib::Absolutepath $pulp_user_home = '/var/lib/pulpcore',
  Stdlib::Host $pulp_api_host = '127.0.0.1',
  Stdlib::Port $pulp_api_port = 24817,
  Stdlib::Host $pulp_content_host = '127.0.0.1',
  Stdlib::Port $pulp_content_port = 24816,
  Stdlib::Absolutepath $pulp_webserver_static_dir = '/var/lib/pulpcore/docroot',
  String $database_name = 'pulpcore',
) {

  $settings_file = "${pulp_config_dir}/settings.py"
  $servername = $facts['fqdn']

  include pulpcore::install
  include pulpcore::database
  include pulpcore::config
  contain pulpcore::service
  include pulpcore::apache

  Class['pulpcore::install'] ~> Class['pulpcore::config', 'pulpcore::service']
  Class['pulpcore::config'] ~> Class['pulpcore::database', 'pulpcore::service']
  Class['pulpcore::database'] -> Class['pulpcore::service'] -> Class['pulpcore::apache']

}
