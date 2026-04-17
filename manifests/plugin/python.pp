# @summary Pulp Python plugin
class pulpcore::plugin::python {
  $pypi_path = '/pypi'
  $pypi_url = "${pulpcore::apache::api_base_url}${pypi_path}"

  $context = {
    'directories' => [
      {
        'provider'        => 'location',
        'path'            => $pypi_path,
        'proxy_pass'      => [
          {
            'url'    => $pypi_url,
            'params' => $pulpcore::apache::api_proxy_params,
          },
        ],
        'request_headers' => [
          'unset X-CLIENT-CERT',
          'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
          'set X-FORWARDED-PROTO expr=%{REQUEST_SCHEME}',
        ],
      },
    ],
  }
  $content = epp('pulpcore/apache-fragment.epp', $context)

  pulpcore::plugin { 'python':
    http_content  => $content,
    https_content => $content,
  }
}
