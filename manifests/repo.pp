# Configure the Pulpcore repo
#
# @param version
#   The Pulpcore version to use
# @param baseurl
#   An optional base URL to be used for yumrepo, instead of the default
# @param gpgkey
#   An optional value for gpgkey to be used for yumrepo, instead of the default.
#   If an empty string is passed, gpgcheck will be disabled.
class pulpcore::repo (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $version = '3.63',
  Optional[Stdlib::HTTPUrl] $baseurl = undef,
  Optional[String[0]] $gpgkey = undef,
) {
  $dist_tag = "el${facts['os']['release']['major']}"

  yumrepo { 'pulpcore':
    descr    => "Pulpcore ${version}",
    baseurl  => pick($baseurl, "https://yum.theforeman.org/pulpcore/${version}/${dist_tag}/\$basearch"),
    enabled  => '1',
    gpgcheck => if $gpgkey == '' or $version == 'nightly' { '0' } else { '1' },
    gpgkey   => pick($gpgkey, "https://yum.theforeman.org/pulpcore/${version}/GPG-RPM-KEY-pulpcore"),
    notify   => Anchor['pulpcore::repo'],
  }

  # An anchor is used because it can be collected
  anchor { 'pulpcore::repo': } # lint:ignore:anchor_resource
}
