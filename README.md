# puppet-pulpcore

Puppet module to set up Pulp 3. The primary goal of the maintainers is to set up Pulp 3 as part of Katello installation, but there's no reason it couldn't be used elsewhere.

## Support policy

The module provides no guarantee for multiple versions. Whenever a version is dropped, the major version is increased. All supported versions are listed.

### Pulpcore 3.6

Due to the use of libexec wrappers, at least python3-pulpcore 3.6.3-2 must be installed
