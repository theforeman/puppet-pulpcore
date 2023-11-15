# Configure the Pulpcore repo
#
# @param version
#   The Pulpcore version to use
#
# @param yum_repo_baseurl
#   The base URL for Yum repositories
class pulpcore::repo (
  Pattern['^\d+\.\d+$'] $version = '3.28',
  Stdlib::HTTPUrl $yum_repo_baseurl = 'https://yum.theforeman.org',
) {
  $dist_tag = "el${facts['os']['release']['major']}"

  $gpgcheck_enabled = $version ? {
    'nightly' => '0',
    default   => '1',
  }

  $context = {
    'version'          => $version,
    'dist_tag'         => $dist_tag,
    'yum_repo_baseurl' => $yum_repo_baseurl,
    'gpgcheck_enabled' => $gpgcheck_enabled,
  }

  file { '/etc/yum.repos.d/pulpcore.repo':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('pulpcore/repo.epp', $context),
    notify  => Anchor['pulpcore::repo'],
  }

  # Only EL8 has DNF modules
  if $dist_tag == 'el8' {
    package { 'pulpcore-dnf-module':
      ensure      => $dist_tag,
      name        => 'pulpcore',
      enable_only => true,
      provider    => 'dnfmodule',
      require     => File['/etc/yum.repos.d/pulpcore.repo'],
      notify      => Anchor['pulpcore::repo'],
    }
  }

  # An anchor is used because it can be collected
  anchor { 'pulpcore::repo': } # lint:ignore:anchor_resource
}
