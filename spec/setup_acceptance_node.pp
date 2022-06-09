$major = $facts['os']['release']['major']

case $major {
  '8': {
    package { 'glibc-langpack-en':
      ensure => installed,
    }
    package { 'centos-release-ansible-29':
      ensure => present,
    }
  }
  default: {}
}

class { 'pulpcore::repo':
  version => fact('pulpcore_version'),
}

# Needed as a workaround for idempotency
if $facts['os']['selinux']['enabled'] {
  package { 'pulpcore-selinux':
    ensure  => installed,
    require => Class['pulpcore::repo'],
  }
}

$directory = '/etc/pulpcore-certs'
$ca_cert = "${directory}/ca-cert.pem"
$ca_key = "${directory}/ca-key.pem"
$client_csr = "${directory}/client-csr.pem"
$client_cert = "${directory}/client-cert.pem"
$client_key = "${directory}/client-key.pem"

$ca_cmd = "openssl req -nodes -x509 -newkey rsa:2048 -subj '/CN=${facts['networking']['fqdn']}' -addext 'subjectAltName = DNS:${facts['networking']['fqdn']}' -keyout '${ca_key}' -out '${ca_cert}' -days 365"

exec { 'Create certificate directory':
  command => "mkdir -p ${directory}",
  path    => ['/bin', '/usr/bin'],
  creates => $directory,
}
-> exec { 'Generate certificate':
  command   => $ca_cmd,
  path      => ['/bin', '/usr/bin'],
  creates   => $ca_cert,
  logoutput => 'on_failure',
  umask     => '0022',
}
-> exec { 'Generate CSR':
  command   => "openssl req -nodes -new -newkey rsa:2048 -subj '/CN=admin' -out '${client_csr}' -keyout '${client_key}'",
  path      => ['/bin', '/usr/bin'],
  creates   => $client_csr,
  logoutput => 'on_failure',
  umask     => '0022',
}
-> exec { 'Sign CSR':
  command   => "openssl x509 -req -days 360 -in '${client_csr}' -CA '${ca_cert}' -CAkey '${ca_key}' -CAcreateserial -out '${client_cert}'",
  path      => ['/bin', '/usr/bin'],
  creates   => $client_cert,
  logoutput => 'on_failure',
  umask     => '0022',
}
-> file { [$ca_key, $ca_cert, $client_key, $client_cert]:
  owner => 'root',
  group => 'root',
  mode  => '0640',
}
