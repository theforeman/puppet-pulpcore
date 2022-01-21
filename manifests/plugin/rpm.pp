# @summary Pulp RPM plugin
# @param use_pulp2_content_route
#   Whether to redirect the legacy (Pulp 2) URLs to the content server
#
# @param keep_changelog_limit
#   Pulpcore's KEEP_CHANGELOG_LIMIT setting. Uses Pulpcore's default when
#   undefined. Increasing this limit will cause pulpcore workers to use more
#   memory when more changelogs are available in the repo metadata.
class pulpcore::plugin::rpm (
  Boolean $use_pulp2_content_route = false,
  Optional[Integer[0]] $keep_changelog_limit = undef,
) {
  if $use_pulp2_content_route {
    $context = {
      'directories' => [
        {
          'provider'        => 'location',
          'path'            => '/pulp/repos',
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

  if $keep_changelog_limit {
    $rpm_plugin_config = "KEEP_CHANGELOG_LIMIT = ${keep_changelog_limit}"
  } else {
    $rpm_plugin_config = undef
  }

  pulpcore::plugin { 'rpm':
    http_content  => $content,
    https_content => $content,
    config        => $rpm_plugin_config,
  }
}
