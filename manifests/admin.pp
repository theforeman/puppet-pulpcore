# @summary Run a python3-django-admin command
#
# @param command
#   The command to run
#
# @param refreshonly
#   The command should only be run as a refresh mechanism for when a dependent
#   object is changed.
#
# @param unless
#   A test command that checks the state of the target system and restricts
#   when the exec can run.
#
# @param path
#   The path to look for commands.
#
# @param pulp_settings
#   The pulp settings file to use
#
# @param static_root
#   Root directory for static content
#
# @see exec
define pulpcore::admin(
  String $command = $title,
  Boolean $refreshonly = false,
  Optional[String] $unless = undef,
  Array[Stdlib::Absolutepath] $path = ['/usr/bin'],
  Stdlib::Absolutepath $pulp_settings = $pulpcore::settings_file,
  Stdlib::Absolutepath $static_root = $pulpcore::pulp_static_root,
) {
  Concat <| title == 'pulpcore settings' |>
  -> exec { "python3-django-admin ${command}":
    path        => $path,
    environment => [
      'DJANGO_SETTINGS_MODULE=pulpcore.app.settings',
      "PULP_SETTINGS=${pulp_settings}",
      "PULP_STATIC_ROOT=${static_root}",
    ],
    refreshonly => $refreshonly,
    unless      => $unless,
  }
}
