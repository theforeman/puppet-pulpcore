# @summary Pulp Container plugin
class pulpcore::plugin::container {
  pulpcore::plugin { 'container':
    config => 'TOKEN_AUTH_DISABLED=True',
  }
}
