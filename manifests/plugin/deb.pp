# @summary Pulp Deb plugin
# @param use_pulp2_content_route
#   Whether to redirect the legacy (Pulp 2) URL, /pulp/deb/, to the content server
# @param force_ignore_missing_package_indices
#   Wheter to set the FORCE_IGNORE_MISSING_PACKAGE_INDICES setting to True or
#   False in /etc/pulp/settings.py.
class pulpcore::plugin::deb (
  Boolean $use_pulp2_content_route = false,
  Boolean $force_ignore_missing_package_indices = true,
) {
  if $use_pulp2_content_route {
    $context = {
      'directories' => [
        {
          'provider'        => 'location',
          'path'            => '/pulp/deb',
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

  $deb_plugin_config_fimpi = to_python($force_ignore_missing_package_indices)

  pulpcore::plugin { 'deb':
    config        => "FORCE_IGNORE_MISSING_PACKAGE_INDICES = ${deb_plugin_config_fimpi}",
    http_content  => $content,
    https_content => $content,
  }
}
