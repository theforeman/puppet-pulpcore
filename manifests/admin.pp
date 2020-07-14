# @summary Run a pulpcore-manager command
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
#   Root directory for static content
#
# @see exec
define pulpcore::admin(
  String $command = $title,
  Boolean $refreshonly = false,
  Optional[String] $unless = undef,
  Array[Stdlib::Absolutepath] $path = ['/usr/bin'],
  Stdlib::Absolutepath $pulp_settings = $pulpcore::settings_file,
) {
  Concat <| title == 'pulpcore settings' |>
  -> exec { "pulpcore-manager ${command}":
    path        => $path,
    environment => ["PULP_SETTINGS=${pulp_settings}"],
    refreshonly => $refreshonly,
    unless      => $unless,
  }
}
