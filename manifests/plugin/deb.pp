# @summary Pulp Deb plugin
# @param use_pulp2_content_route Whether to redirect the legacy (Pulp 2) URL, /pulp/deb/, to the content server
class pulpcore::plugin::deb (
  Boolean $use_pulp2_content_route = false,
) {
  if $use_pulp2_content_route {
    $context = {
      'directories' => [
        {
          'provider'        => 'location',
          'path'            => '/pulp/deb',
          'proxy_pass'      => [
            {
              'url' => $pulpcore::apache::content_url,
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

  pulpcore::plugin { 'deb':
    http_content  => $content,
    https_content => $content,
  }
}
