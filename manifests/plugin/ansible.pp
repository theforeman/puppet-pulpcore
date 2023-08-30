# @summary Pulp Ansible plugin
# @param ansible_galaxy_path
#   In the Apache configuration the path to forward to the api app
#   for ansible galaxy support
class pulpcore::plugin::ansible (
  String $ansible_galaxy_path = '/pulp_ansible/galaxy/',
) {
  $context = {
    'directories' => [],
    'proxy_pass'  => [
      {
        'path' => $ansible_galaxy_path,
        'url'  => "${pulpcore::apache::api_base_url}${ansible_galaxy_path}",
      },
    ],
  }

  if ! $pulpcore::apache_https_vhost {
    fail('HTTPS must be turned on for Ansible content')
  } elsif $pulpcore::apache::https_port != 443 {
    $external_content_url = "https://${pulpcore::servername}:${pulpcore::apache::https_port}${pulpcore::apache::content_path}"
    $external_api_url = "https://${pulpcore::servername}:${pulpcore::apache::https_port}"
  } else {
    $external_content_url = "https://${pulpcore::servername}${pulpcore::apache::content_path}"
    $external_api_url = "https://${pulpcore::servername}"
  }

  pulpcore::plugin { 'ansible':
    config        => "ANSIBLE_API_HOSTNAME = \"${external_api_url}\"\nANSIBLE_CONTENT_HOSTNAME = \"${external_content_url}\"\nANSIBLE_PERMISSION_CLASSES = []",
    https_content => epp('pulpcore/apache-fragment.epp', $context),
  }
}
