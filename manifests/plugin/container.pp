# @summary Pulp Container plugin
# @param location_prefix
#   In the Apache configuration a location with this prefix is exposed. The
#   version (currently v2) will be appended.
# @param registry_version_path
#   The path beneath the location prefix to forward. This is also appended to
#   the content base url.
class pulpcore::plugin::container (
  String $location_prefix = '/pulpcore_registry',
  String $registry_version_path = '/v2/',
) {
  $api_default_request_headers = [
    "unset ${pulpcore::apache::remote_user_environ_header}",
  ]

  $api_additional_request_headers = $pulpcore::api_client_auth_cn_map.map |String $cn, String $pulp_user| {
    "set ${pulpcore::apache::remote_user_environ_header} \"${pulp_user}\" \"expr=%{SSL_CLIENT_S_DN_CN} == '${cn}'\""
  }

  $context = {
    'directories' => [
      {
        'provider'        => 'location',
        'path'            => "${location_prefix}${registry_version_path}",
        'proxy_pass'      => [
          {
            'url' => "${pulpcore::apache::api_base_url}${registry_version_path}",
          },
        ],
        'request_headers' => $api_default_request_headers + $api_additional_request_headers,
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
    config        => 'TOKEN_AUTH_DISABLED=True',
    https_content => epp('pulpcore/apache-fragment.epp', $context),
  }
}
