# Configure an Apache vhost
# @api private
class pulpcore::apache (
  Boolean $manage_selinux_boolean = true,
  Stdlib::Port $http_port = 80,
  Stdlib::Port $https_port = 443,
  Hash[String, Any] $http_vhost_options = {},
  Hash[String, Any] $https_vhost_options = {},
  Enum['none', 'optional', 'require', 'optional_no_ca'] $ssl_verify_client = 'optional',
  Hash $content_proxy_params = {'timeout' => '600', 'disablereuse' => 'on'},
  Hash $api_proxy_params = {'timeout' => '600'},
) {
  include pulpcore

  $vhost_priority = $pulpcore::apache_vhost_priority
  $api_path = '/pulp/api/v3'
  $api_base_url = "unix://${pulpcore::api_socket_path}|http://pulpcore-api"
  $api_url = "${api_base_url}${api_path}"
  $content_path = '/pulp/content'
  $content_base_url = "unix://${pulpcore::content_socket_path}|http://pulpcore-content"
  $content_url = "${content_base_url}${content_path}"

  $docroot_directory = {
    'provider'       => 'Directory',
    'path'           => $pulpcore::apache_docroot,
    'options'        => ['-Indexes', '-FollowSymLinks'],
    'allow_override' => ['None'],
  }
  $content_directory = {
    'path'            => $content_path,
    'provider'        => 'location',
    'proxy_pass'      => [
      {
        'url'    => $content_url,
        'params' => $content_proxy_params,
      },
    ],
    'request_headers' => [
      'unset X-CLIENT-CERT',
      'set X-CLIENT-CERT "%{SSL_CLIENT_CERT}s" env=SSL_CLIENT_CERT',
    ],
  }

  # Pulp has a default for remote header. Here it's ensured that the end user
  # can't send that header to spoof users.
  $remote_user_environ_header = $pulpcore::remote_user_environ_name.regsubst(/^HTTP_/, '')

  $api_default_request_headers = [
    "unset ${remote_user_environ_header}",
    "set ${remote_user_environ_header} \"%{SSL_CLIENT_S_DN_CN}s\" env=SSL_CLIENT_S_DN_CN",
  ]

  $api_additional_request_headers = $pulpcore::api_client_auth_cn_map.map |String $cn, String $pulp_user| {
    "set ${remote_user_environ_header} \"${pulp_user}\" \"expr=%{SSL_CLIENT_S_DN_CN} == '${cn}'\""
  }

  $api_directory = {
    'path'            => $api_path,
    'provider'        => 'location',
    'proxy_pass'      => [
      {
        'url'    => $api_url,
        'params' => $api_proxy_params,
      },
    ],
    'request_headers' => $api_default_request_headers + $api_additional_request_headers,
  }

  # Static content is served by the whitenoise application. SELinux prevents
  # Apache from serving it directly
  $proxy_pass_static = {
    'path' => $pulpcore::static_url,
    'url'  => "${api_base_url}${pulpcore::static_url}",
  }

  case $pulpcore::apache_http_vhost {
    true: {
      $http_vhost_name = 'pulpcore'
      $http_fragment = undef

      include apache
      include apache::mod::headers
      apache::vhost { $http_vhost_name:
        servername     => $pulpcore::servername,
        port           => $http_port,
        priority       => $vhost_priority,
        docroot        => $pulpcore::apache_docroot,
        manage_docroot => false,
        directories    => [$docroot_directory, $content_directory],
        *              => $http_vhost_options,
      }
    }
    false: {
      $http_vhost_name = undef
      $http_fragment = undef
    }
    default: {
      $http_vhost_name = $pulpcore::apache_http_vhost
      $http_fragment = epp('pulpcore/apache-fragment.epp', {
          'directories' => [$content_directory],
      })
    }
  }

  case $pulpcore::apache_https_vhost {
    true: {
      $https_vhost_name = 'pulpcore-https'
      $https_fragment = undef

      include apache
      include apache::mod::headers
      apache::vhost { $https_vhost_name:
        servername        => $pulpcore::servername,
        port              => $https_port,
        ssl               => true,
        priority          => $vhost_priority,
        docroot           => $pulpcore::apache_docroot,
        manage_docroot    => false,
        directories       => [$docroot_directory, $content_directory, $api_directory],
        proxy_pass        => [$proxy_pass_static],
        ssl_cert          => $pulpcore::apache_https_cert,
        ssl_key           => $pulpcore::apache_https_key,
        ssl_chain         => $pulpcore::apache_https_chain,
        ssl_ca            => $pulpcore::apache_https_ca,
        ssl_verify_client => $ssl_verify_client,
        *                 => $https_vhost_options,
      }
    }
    false: {
      $https_vhost_name = undef
      $https_fragment = undef
    }
    default: {
      $https_vhost_name = $pulpcore::apache_https_vhost
      $https_fragment = epp('pulpcore/apache-fragment.epp', {
          'directories' => [$content_directory, $api_directory],
          'proxy_pass'  => [$proxy_pass_static],
      })
    }
  }

  if $pulpcore::apache_http_vhost == true or $pulpcore::apache_https_vhost == true {
    file { $pulpcore::apache_docroot:
      ensure => directory,
      owner  => $pulpcore::user,
      group  => $pulpcore::group,
      mode   => '0755',
    }
  }

  if $http_fragment or $https_fragment {
    pulpcore::apache::fragment { 'pulpcore':
      http_content  => $http_fragment,
      https_content => $https_fragment,
    }
  }

  if $manage_selinux_boolean and ($pulpcore::apache_http_vhost or $pulpcore::apache_https_vhost) {
    # Doesn't use selinux::boolean since that doesn't use ensure_resource which
    # then conflict with the foreman module which doesn't use the selinux module.
    if $facts['os']['selinux']['enabled'] {
      ensure_resource('selboolean', 'httpd_can_network_connect', {
          value      => 'on',
          persistent => true,
      })
    }
  }
}
