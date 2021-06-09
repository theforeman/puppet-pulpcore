# @summary Pulp Ansible plugin
# @param ansible_galaxy_path
#   In the Apache configuration the path to forward to the api app
#   for ansible galaxy support
class pulpcore::plugin::ansible(
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

  pulpcore::plugin { 'ansible':
    config        => "ANSIBLE_API_HOSTNAME = \"${pulpcore::servername}\"\nANSIBLE_CONTENT_HOSTNAME = \"${pulpcore::apache::external_content_url}\"",
    https_content => epp('pulpcore/apache-fragment.epp', $context),
  }
}
