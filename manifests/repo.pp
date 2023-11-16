# Configure the Pulpcore repo
#
# @param version
#   The Pulpcore version to use
class pulpcore::repo (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $version = '3.28',
) {
  $dist_tag = "el${facts['os']['release']['major']}"

  yumrepo { 'pulpcore':
    name     => "Pulpcore ${version}",
    baseurl  => "https://yum.theforeman.org/pulpcore/${version}/${dist_tag}/\$basearch",
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => "https://yum.theforeman.org/pulpcore/${version}/GPG-RPM-KEY-pulpcore",
    notify   => Anchor['pulpcore::repo'],
  }

  # Only EL8 has DNF modules
  if $dist_tag == 'el8' {
    package { 'pulpcore-dnf-module':
      ensure      => $dist_tag,
      name        => 'pulpcore',
      enable_only => true,
      provider    => 'dnfmodule',
      require     => Yumrepo['pulpcore'],
      notify      => Anchor['pulpcore::repo'],
    }
  }

  # An anchor is used because it can be collected
  anchor { 'pulpcore::repo': } # lint:ignore:anchor_resource
}
