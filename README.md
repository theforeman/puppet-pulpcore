# puppet-pulpcore
Puppet module for setting up Pulp 3 as part of Katello installation

# Pulpcore 3.2

We are adding a few new settings to make the installer compatible with pulpcore 3.2. These settings are not available in releases prior to 3.2 and should not be used in earlier versions.                                            

**ALLOWED_IMPORT_PATHS** : This setting whitelists paths that can be used for repository sync with file protocol. Katello uses the path /var/lib/pulp/sync_imports/ to run tests. For more information on this, see [https://docs.pulpproject.org/settings.html#allowed-import-paths](https://docs.pulpproject.org/settings.html#allowed-import-paths).

**AUTHENTICATION_BACKENDS , REST_FRAMEWORK__DEFAULT_AUTHENTICATION_CLASSES** : 
The defaults that katello uses are defined in [templates/settings.py.erb](https://github.com/theforeman/puppet-pulpcore/blob/master/templates/settings.py.erb). For more information on these authentication settings, see [https://docs.pulpproject.org/installation/authentication.html](https://docs.pulpproject.org/installation/authentication.html) 
