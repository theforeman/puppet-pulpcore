# @summary Pulp Container plugin
# @param location_prefix
#   In the Apache configuration a location with this prefix is exposed. The
#   version (currently v2) will be appended.
class pulpcore::plugin::container (
  String $location_prefix = '/pulpcore_registry',
) {
  $context = {
    'directories' => [
      {
        'provider'        => 'location',
        'path'            => $location_prefix,
        'proxy_pass'      => [
          {
            'url' => $pulpcore::apache::api_base_url,
          },
        ],
        'request_headers' => $pulpcore::apache::api_default_request_headers + $pulpcore::apache::api_additional_request_headers,
      },
    ],
    'proxy_pass'  => [
      {
        'path' => '/pulp/container/',
        'url'  => "${pulpcore::apache::content_base_url}/pulp/container/",
      },
    ],
  }

  pulpcore::plugin { 'container':
    config        => "TOKEN_AUTH_DISABLED=True\nFLATPAK_INDEX=True",
    https_content => epp('pulpcore/apache-fragment.epp', $context),
  }
}
