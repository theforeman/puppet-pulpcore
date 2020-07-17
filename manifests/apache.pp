# Configure an Apache vhost
# @api private
class pulpcore::apache {
  $api_path = '/pulp/api/v3'
  $api_url = "http://${pulpcore::api_host}:${pulpcore::api_port}${api_path}"
  $content_path = '/pulp/content'
  $content_url = "http://${pulpcore::content_host}:${pulpcore::content_port}${content_path}"

  if $pulpcore::manage_apache {
    include apache
    apache::vhost { 'pulpcore':
      servername     => $pulpcore::servername,
      port           => 80,
      priority       => '10',
      docroot        => $pulpcore::apache_docroot,
      docroot_owner  => $pulpcore::user,
      docroot_group  => $pulpcore::group,
      docroot_mode   => '0755',
      manage_docroot => true,
      proxy_pass     => [
        {
          'path'         => $api_path,
          'url'          => $api_url,
          'reverse_urls' => [$api_url],
        },
        {
          'path'         => $content_path,
          'url'          => $content_url,
          'reverse_urls' => [$content_url],
        },
      ],
    }

    if $facts['os']['selinux']['enabled'] {
      selinux::boolean { 'httpd_can_network_connect': }
    }
  }
}
