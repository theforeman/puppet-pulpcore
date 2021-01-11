# @summary Pulp File plugin
# @param use_pulp2_content_route
#   Whether to redirect the legacy (Pulp 2) URLs to the content server
class pulpcore::plugin::file (
  Boolean $use_pulp2_content_route = false,
) {
  if $use_pulp2_content_route {
    $context = {
      'directories' => [
        {
          'provider'        => 'location',
          'path'            => '/pulp/isos',
          'proxy_pass'      => [
            {
              'url'    => $pulpcore::apache::content_url,
              'params' => $pulpcore::apache::content_proxy_params,
            },
          ],
          'request_headers' => [
            'unset X-CLIENT-CERT',
            'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
          ],
        },
      ],
    }
    $content = epp('pulpcore/apache-fragment.epp', $context)
  } else {
    $content = undef
  }

  pulpcore::plugin { 'file':
    http_content  => $content,
    https_content => $content,
  }
}
