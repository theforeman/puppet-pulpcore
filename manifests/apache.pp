# Configure an Apache vhost
# @api private
class pulpcore::apache {
  $pulp_api_path = '/pulp/api'
  $pulp_api_url = "http://${pulpcore::pulp_api_host}:${pulpcore::pulp_api_port}/pulp/api"
  $pulp_content_path = '/pulp/content'
  $pulp_content_url = "http://${pulpcore::pulp_content_host}:${pulpcore::pulp_content_port}/pulp/content"

  include apache
  apache::vhost { 'pulp':
    servername => $pulpcore::servername,
    port       => 80,
    priority   => '10',
    docroot    => $pulpcore::pulp_webserver_static_dir,
    proxy_pass => [
      {
        'path'         => $pulp_api_path,
        'url'          => $pulp_api_url,
        'reverse_urls' => [$pulp_api_path, $pulp_api_url],
      },
      {
        'path'         => $pulp_content_path,
        'url'          => $pulp_content_url,
        'reverse_urls' => [$pulp_content_path, $pulp_content_url],
      },
    ],
  }
}
