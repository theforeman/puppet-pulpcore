# @summary Pulp Ostree plugin
#
# This plugin is not packaged on EL7.
class pulpcore::plugin::ostree {
  pulpcore::plugin { 'ostree': }
}
