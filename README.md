# puppet-pulpcore
This is a Puppet module for setting up Pulp 3 as part of a Katello installation. It can also be utilized to deploy a standalone Pulp 3.

### Quick Start Guide

# Setting up the Test Environment

1. Install Libvirt + Vagrant-Libvirt (used in the below examples)
2. In the puppet-pulpcore directory, execute `$ bundle install`

# Running a Single Spec Test

```
$ SPEC_FACTS_OS=centos-7-x86_64 bundle exec rspec spec/classes/pulpcore_spec.rb
```

# Running Acceptance Tests

```
$ BEAKER_HYPERVISOR=vagrant_libvirt BEAKER_provision=yes BEAKER_destroy=yes BEAKER_setfile=centos7-64 bundle exec rspec spec/acceptance/basic_spec.rb
```

See `CONTRIBUTING.md` for more detailed instructions.