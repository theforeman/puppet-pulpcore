# Configure the Pulpcore repo
#
# @param version
#   The Pulpcore version to use
class pulpcore::repo (
  Pattern['^\d+\.\d+$'] $version = '3.7',
) {
  $context = {
    'version'   => $version,
    'dist_tag' => "el${facts['os']['release']['major']}",
  }

  file { '/etc/yum.repos.d/pulpcore.repo':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('pulpcore/repo.epp', $context),
    notify  => Anchor['pulpcore::repo'],
  }

  # An anchor is used because it can be collected
  anchor { 'pulpcore::repo': } # lint:ignore:anchor_resource
}
