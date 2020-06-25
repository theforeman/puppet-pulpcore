# @summary Deploy an Apache fragment. Only intended to be used within the module
# @param order
#   This determines the order. See apache::vhost for more details.
#   165 is chosen because it's just before the Proxy setup. In Foreman a
#   ProxyPass /pulp ! is generated and by placing all content before that, a
#   broken setup is avoided.
# @api private
define pulpcore::apache::fragment (
  Optional[String] $http_content = undef,
  Optional[String] $https_content = undef,
  Integer[0] $order = 165,
) {
  include pulpcore::apache

  if $pulpcore::apache::http_vhost_name and $http_content {
    apache::vhost::fragment { "pulpcore-http-${title}":
      vhost    => $pulpcore::apache::http_vhost_name,
      priority => $pulpcore::apache::vhost_priority,
      content  => $http_content,
      order    => $order,
    }
  }

  if $pulpcore::apache::https_vhost_name and $https_content {
    apache::vhost::fragment { "pulpcore-https-${title}":
      vhost    => $pulpcore::apache::https_vhost_name,
      priority => $pulpcore::apache::vhost_priority,
      content  => $https_content,
      order    => $order,
    }
  }
}
