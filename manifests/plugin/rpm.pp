# @summary Pulp RPM plugin
# @param use_pulp2_content_route
#   Whether to redirect the legacy (Pulp 2) URLs to the content server
#
# @param keep_changelog_limit
#   Pulpcore's KEEP_CHANGELOG_LIMIT setting. Uses Pulpcore's default when
#   undefined. Increasing this limit will cause pulpcore workers to use more
#   memory when more changelogs are available in the repo metadata.
#
# @param allow_automatic_unsafe_advisory_conflict_resolution
#   Allow resolving of conflicts due to duplicate advisory ids with different creation dates
#   https://docs.pulpproject.org/pulp_rpm/settings.html#allow-automatic-unsafe-advisory-conflict-resolution
class pulpcore::plugin::rpm (
  Boolean $use_pulp2_content_route = false,
  Optional[Integer[0]] $keep_changelog_limit = undef,
  Boolean $allow_automatic_unsafe_advisory_conflict_resolution = false,
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

  if $keep_changelog_limit or $allow_automatic_unsafe_advisory_conflict_resolution {
    $rpm_plugin_config = epp('pulpcore/settings-rpm.py.epp', {
        'allow_auacr'          => $allow_automatic_unsafe_advisory_conflict_resolution,
        'keep_changelog_limit' => $keep_changelog_limit,
    })
  } else {
    $rpm_plugin_config = undef
  }

  pulpcore::plugin { 'rpm':
    http_content  => $content,
    https_content => $content,
    config        => $rpm_plugin_config,
  }
}
