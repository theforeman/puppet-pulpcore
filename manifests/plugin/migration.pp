# @summary Pulp 2 to Pulp 3 Migration Plugin
class pulpcore::plugin::migration {
  pulpcore::plugin { 'migration':
    package_name => 'python3-pulp-2to3-migration',
    config       => template('pulpcore/migration-settings.py.erb'),
  }
}
