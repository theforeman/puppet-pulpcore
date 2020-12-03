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
  String $registry_base_url = '',
) {

  if $registry_base_url == '' {
    $_registry_base_url = $pulpcore::apache::api_base_url
  } else {
    $_registry_base_url = $registry_base_url
  }

  $context = {
    'directories' => [
      {
        'provider'        => 'location',
        'path'            => "${location_prefix}${registry_version_path}",
        'proxy_pass'      => [
          {
            'url' => "${_registry_base_url}${registry_version_path}",
          },
        ],
        'request_headers' => [
          "unset ${pulpcore::apache::remote_user_environ_header}",
          "set ${pulpcore::apache::remote_user_environ_header} \"%{SSL_CLIENT_S_DN_CN}s\" env=SSL_CLIENT_S_DN_CN",
        ],
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
