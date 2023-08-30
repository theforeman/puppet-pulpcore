# @summary Pulp Ansible plugin
# @param ansible_galaxy_path
#   In the Apache configuration the path to forward to the api app
#   for ansible galaxy support
# @param permission_classes
#   Configure the RBAC permission classes
class pulpcore::plugin::ansible (
  String $ansible_galaxy_path = '/pulp_ansible/galaxy/',
  Optional[Array[String[1]]] $permission_classes = undef,
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

  $config_context = {
    'external_api_url'     => $external_api_url,
    'external_content_url' => $external_content_url,
    'permission_classes'   => $permission_classes,
  }

  pulpcore::plugin { 'ansible':
    config        => epp('pulpcore/settings-ansible.py.epp', $config_context),
    https_content => epp('pulpcore/apache-fragment.epp', $context),
  }
}
